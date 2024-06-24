# Create EKS cluster
resource "aws_eks_cluster" "r_eks_cluster" {
  name     = "${local.base_name}-cluster"
  role_arn = aws_iam_role.r_eks_cluster_role.arn
  # enabled_cluster_log_types = var.eks_cluster_log_types
  version = var.eks_version

  vpc_config {
    subnet_ids              = [var.control_plane_subnets[0].id, var.control_plane_subnets[1].id]
    endpoint_private_access = true
    endpoint_public_access  = false
    # cluster_security_group_id = aws_security_group.r_eks_cluster_sg.id
    security_group_ids = [aws_security_group.r_eks_cluster_sg.id]
    # vpc_id = var.vpc_id
  }

  # depends_on = [aws_cloudwatch_log_group.r_eks_cluster_log_group]
}

# OIDC configuration
resource "aws_iam_openid_connect_provider" "r_oidc_connect_provider" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.d_tls_certificate.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.r_eks_cluster.identity[0].oidc[0].issuer
}

# EKS addons
# VPC CNI Addon
# resource "aws_eks_addon" "r_eks-addons" {
#   count = length(var.eks_addons)
#   cluster_name  = aws_eks_cluster.r_eks_cluster.name
#   addon_name    = var.eks_addons[count.index]
#   addon_version = data.aws_eks_addon_version.d_eks_addons[count.index].version
#   resolve_conflicts_on_update = "PRESERVE"
# }

resource "aws_eks_addon" "r_vpc_cni-addon" {
  cluster_name                = aws_eks_cluster.r_eks_cluster.name
  addon_name                  = "vpc-cni"
  addon_version               = data.aws_eks_addon_version.d_eks_vpc-cni_addon.version
  resolve_conflicts_on_update = "PRESERVE"
  service_account_role_arn    = aws_iam_role.r_vpc_cni_role.arn
  depends_on                  = [aws_eks_cluster.r_eks_cluster, aws_eks_node_group.r_eks_node_group]
}

resource "aws_eks_addon" "r_coredns-addon" {
  cluster_name                = aws_eks_cluster.r_eks_cluster.name
  addon_name                  = "coredns"
  addon_version               = data.aws_eks_addon_version.d_eks_coredns_addon.version
  resolve_conflicts_on_update = "PRESERVE"
  # resolve_conflicts = "OVERWRITE"
  timeouts {
    create = "5m"
  }
  depends_on = [aws_eks_cluster.r_eks_cluster, aws_eks_node_group.r_eks_node_group]
}

resource "aws_eks_addon" "r_kube-proxy-addon" {
  cluster_name                = aws_eks_cluster.r_eks_cluster.name
  addon_name                  = "kube-proxy"
  addon_version               = data.aws_eks_addon_version.d_eks_kube-proxy_addon.version
  resolve_conflicts_on_update = "PRESERVE"
  depends_on                  = [aws_eks_cluster.r_eks_cluster, aws_eks_node_group.r_eks_node_group]
}

resource "aws_eks_addon" "r_aws-ebs-csi-driver-addon" {
  cluster_name                = aws_eks_cluster.r_eks_cluster.name
  addon_name                  = "aws-ebs-csi-driver"
  addon_version               = data.aws_eks_addon_version.d_eks_aws-ebs-csi-driver_addon.version
  resolve_conflicts_on_update = "PRESERVE"
  service_account_role_arn    = aws_iam_role.r_ebs_csi_role.arn
  timeouts {
    create = "5m"
  }
  depends_on = [aws_eks_cluster.r_eks_cluster, aws_eks_node_group.r_eks_node_group]
}

resource "aws_eks_addon" "r_aws-efs-csi-driver-addon" {
  cluster_name                = aws_eks_cluster.r_eks_cluster.name
  addon_name                  = "aws-efs-csi-driver"
  addon_version               = data.aws_eks_addon_version.d_eks_aws-efs-csi-driver_addon.version
  resolve_conflicts_on_update = "PRESERVE"
  service_account_role_arn    = aws_iam_role.r_efs_csi_role.arn
  timeouts {
    create = "5m"
  }
  depends_on = [aws_eks_cluster.r_eks_cluster, aws_eks_node_group.r_eks_node_group]
}

# Node Group configuration

resource "aws_eks_node_group" "r_eks_node_group" {
  cluster_name    = aws_eks_cluster.r_eks_cluster.name
  node_group_name = "${local.base_name}-node-group"
  node_role_arn   = aws_iam_role.r_eks_node_role.arn
  subnet_ids      = [var.nodegroup_subnets[0].id, var.nodegroup_subnets[1].id]
  instance_types  = var.nodegroup_instance_type
  disk_size       = var.nodegroup_disk_size
  ami_type        = "AL2_x86_64"
  # ami_type        = data.aws_ssm_parameter.eks_ami_release_version.id
  #   capacity_type   = var.eks_node_group_capacity_type
  version = var.eks_version
  scaling_config {
    desired_size = var.nodegroup_desired_size
    max_size     = var.nodegroup_max_size
    min_size     = var.nodegroup_min_size
  }
  # Optional: Allow external changes without Terraform plan difference
  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
  remote_access {
    ec2_ssh_key               = var.ssh_key
    source_security_group_ids = [aws_security_group.r_eks_node_group_sg.id]
  }
}
