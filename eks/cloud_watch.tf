# resource "aws_cloudwatch_log_group" "r_eks_cluster_log_group" {
#     name              = "/aws/eks/${local.base_name}-cluster/cluster"
#     retention_in_days = 7  
# }