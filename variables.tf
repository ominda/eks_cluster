variable "v_region" {
  type    = string
  default = "ap-southeast-1"
}

variable "v_default_tags" {
  type = map(string)
}

# VPC variables
variable "v_primary_cidr_block" {
  type = string
}

variable "v_cidr_blocks" {
  type = map(string)
}

# Public subnets
variable "v_public_subnets" {
  type = map(list(string))
}

variable "v_private_subnets" {
  type = map(list(string))
}

variable "v_db_subnets" {
  type = list(string)
}

variable "v_node_group_subnets" {
  type = list(string)
}

# EC2 variables
variable "v_public_ec2_count" {
  type = number
}
variable "v_ssh_key_pair" {
  type = string
}


# EKS variables
variable "v_eks_version" {
  type = string
}

variable "v_eks_cluster_log_types" {
  type = list(string)
}

variable "v_eks_lb_service_role" {
  type = string
}

# variable "v_eks_addons" {
#   type = list(string)
# }

variable "v_node_group_instance_type" {}

variable "v_node_group_disk_size" {
  type = number
}

variable "v_node_group_desired_size" {}
variable "v_node_group_max_size" {}
variable "v_node_group_min_size" {}