
output "endpoint" {
  value = aws_eks_cluster.r_eks_cluster.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.r_eks_cluster.certificate_authority[0].data
}

output "addon_versions" {
  value = { "vpc_cni" = data.aws_eks_addon_version.d_eks_vpc-cni_addon.version,
    "coredns"    = data.aws_eks_addon_version.d_eks_coredns_addon.version,
    "kube_proxy" = data.aws_eks_addon_version.d_eks_kube-proxy_addon.version,
    "ebs_csi"    = data.aws_eks_addon_version.d_eks_aws-ebs-csi-driver_addon.version,
    "efs_csi"    = data.aws_eks_addon_version.d_eks_aws-efs-csi-driver_addon.version
  }
}

# output "vpc_cni_addon_version" {
#   value = data.aws_eks_addon_version.d_eks_vpc-cni_addon.version
# }

# output "coredns_addon_version" {
#   value = data.aws_eks_addon_version.d_eks_coredns_addon.version
# }

# output "kube_proxy_addon_version" {
#   value = data.aws_eks_addon_version.d_eks_kube-proxy_addon.version
# }

# output "ebs_csi_addon_version" {
#   value = data.aws_eks_addon_version.d_eks_aws-ebs-csi-driver_addon.version
# }

# output "efs_csi_addon_version" {
#   value = data.aws_eks_addon_version.d_eks_aws-efs-csi-driver_addon.version
# }

output "oidc_issure_url" {
  value = aws_eks_cluster.r_eks_cluster.identity[0].oidc[0].issuer
}