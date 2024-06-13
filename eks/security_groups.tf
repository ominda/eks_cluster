# EKS control plane security group
resource "aws_security_group" "r_eks_cluster_sg" {
  name        = "${local.base_name}-Control_Plane-SG"
  description = "Allow SSH and https trafic to the hosts"
  vpc_id      = var.vpc_id

  ingress  {
    from_port = 6443
    to_port = 6443
    protocol = "TCP"
    security_groups =  [var.bastion_sg.id]
  }

  ingress  {
    from_port = 443
    to_port = 443
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
    ingress  {
    from_port = 22
    to_port = 22
    protocol = "TCP"
    security_groups =  [var.bastion_sg.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.base_name}-Control_Plane-SG"
  }
}

# EKS node group security group
resource "aws_security_group" "r_eks_node_group_sg" {
  name        = "${local.base_name}-Node_Group-SG"
  description = "Allow SSH and https trafic to the hosts"
  vpc_id      = var.vpc_id

  ingress  {
    from_port = 0
    to_port = 65535
    protocol = "TCP"
    security_groups = [aws_security_group.r_eks_cluster_sg.id]
  }

  ingress  {
    from_port = 443
    to_port = 443
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress  {
    from_port = 22
    to_port = 22
    protocol = "TCP"
    security_groups =  [var.bastion_sg.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.base_name}-Node_Group-SG"
  }
}