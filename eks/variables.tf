variable "project" {}
variable "environment" {}
variable "control_plane_subnets" {}
variable "vpc_id" {}
variable "eks_version" {}
# variable "eks_addons" {}
variable "eks_cluster_log_types" {}
variable "nodegroup_subnets" {}
variable "nodegroup_instance_type" {}
variable "nodegroup_disk_size" {}
variable "nodegroup_desired_size" {}
variable "nodegroup_max_size" {}
variable "nodegroup_min_size" {}
variable "utility_subnets" {}
variable "ssh_key" {}
variable "bastion_sg" {}