# OIDC configuration
data "tls_certificate" "d_tls_certificate" {
  url = aws_eks_cluster.r_eks_cluster.identity[0].oidc[0].issuer
}

# EKS addons
# data "aws_eks_addon_version" "d_eks_addons" {
#   count = length(var.eks_addons)
#   addon_name         = var.eks_addons[count.index]
#   kubernetes_version = aws_eks_cluster.r_eks_cluster.version
#   most_recent        = true
# }

data "aws_eks_addon_version" "d_eks_vpc-cni_addon" {
  addon_name         = "vpc-cni"
  kubernetes_version = aws_eks_cluster.r_eks_cluster.version
  most_recent        = true
}

data "aws_eks_addon_version" "d_eks_coredns_addon" {
  addon_name         = "coredns"
  kubernetes_version = aws_eks_cluster.r_eks_cluster.version
  most_recent        = true
}

data "aws_eks_addon_version" "d_eks_kube-proxy_addon" {
  addon_name         = "kube-proxy"
  kubernetes_version = aws_eks_cluster.r_eks_cluster.version
  most_recent        = true
}

data "aws_eks_addon_version" "d_eks_aws-ebs-csi-driver_addon" {
  addon_name         = "aws-ebs-csi-driver"
  kubernetes_version = aws_eks_cluster.r_eks_cluster.version
  most_recent        = true
}

data "aws_eks_addon_version" "d_eks_aws-efs-csi-driver_addon" {
  addon_name         = "aws-efs-csi-driver"
  kubernetes_version = aws_eks_cluster.r_eks_cluster.version
  most_recent        = true
}

# Node Group AMI
data "aws_ssm_parameter" "eks_ami_release_version" {
  name = "/aws/service/eks/optimized-ami/${aws_eks_cluster.r_eks_cluster.version}/amazon-linux-2/recommended/release_version"
}
