# Create EKS cluster role. let the cluster to make API calls to other AWS resources
resource "aws_iam_role" "r_eks_cluster_role" {
  name                = "${local.base_name}-cluster-role"
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonEKSClusterPolicy", "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"]
  assume_role_policy  = data.aws_iam_policy_document.d_eks_cluster_assume_role.json
}

resource "aws_iam_role" "r_vpc_cni_role" {
  name                = "${local.base_name}-vpc_cni_addon-role"
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"]
  assume_role_policy  = data.aws_iam_policy_document.d_eks_vpc_cni_assume_role.json
}

resource "aws_iam_role" "r_efs_csi_role" {
  name                = "${local.base_name}-efs_csi_addon-role"
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"]
  assume_role_policy  = data.aws_iam_policy_document.d_eks_efs_csi_assume_role.json
}

resource "aws_iam_role" "r_ebs_csi_role" {
  name                = "${local.base_name}-ebs_csi_addon-role"
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"]
  assume_role_policy  = data.aws_iam_policy_document.d_eks_ebs_csi_assume_role.json
}

# Create EKS Node Role
resource "aws_iam_role" "r_eks_node_role" {
  name = "${local.base_name}-node-role"
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  ]
  assume_role_policy = data.aws_iam_policy_document.d_eks_node_assume_role.json
}

# create LB policy
resource "aws_iam_policy" "r_eks_lb_policy" {
  name        = "AWSLoadBalancerControllerIAMPolicy"
  description = "EKS load balanacer controller policy"
  policy      = data.aws_iam_policy_document.d_eks_load_balancer_controller.json
}

# Attach LB policy to the role
resource "aws_iam_role_policy_attachment" "r_eks_lb_role_attachment" {
  role       = aws_iam_role.r_eks_load_balancer_role.name
  policy_arn = aws_iam_policy.r_eks_lb_policy.arn
}

# Create load balancer controler role
resource "aws_iam_role" "r_eks_load_balancer_role" {
  name = "${local.base_name}-loadbalancer-role"
  assume_role_policy = data.aws_iam_policy_document.r_eks_lb_assume_role.json
}