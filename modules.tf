module "vpc" {
  source                = "./vpc"
  project               = var.v_default_tags["project"]
  environment           = var.v_default_tags["environment"]
  primary_cidr          = var.v_primary_cidr_block
  cidrs                 = var.v_cidr_blocks
  public_subnets        = var.v_public_subnets["public_subnets"]
  public_lb_subnets     = var.v_public_subnets["internet_lbs_subnets"]
  control_plane_subnets = var.v_private_subnets["control_plane_subnets"]
  internal_lb_subnets   = var.v_private_subnets["internal_lb_subnets"]
  tgw_subnets           = var.v_private_subnets["tgw_subnets"]
  private_nat_subnets   = var.v_private_subnets["private_nat_subnets"]
  efs_subnets           = var.v_private_subnets["efs_subnets"]
  utility_subnets       = var.v_private_subnets["utility_subnets"]
  db_subnets = var.v_db_subnets
  node_group_subnets = var.v_node_group_subnets
}

module "ec2" {
  source = "./ec2"
  project               = var.v_default_tags["project"]
  environment           = var.v_default_tags["environment"]
  ssh_key = var.v_ssh_key_pair
  public_subnets = module.vpc.o_public_subnets
  vpc_id = module.vpc.o_vpc.id
  public_ec2_count = var.v_public_ec2_count
}

module "eks" {
  source = "./eks"
  project               = var.v_default_tags["project"]
  environment           = var.v_default_tags["environment"]
  control_plane_subnets = module.vpc.o_control_plane_subnets
  utility_subnets = module.vpc.o_utility_subnets
  vpc_id = module.vpc.o_vpc.id 
  eks_version = var.v_eks_version
  eks_cluster_log_types = var.v_eks_cluster_log_types
  nodegroup_subnets = module.vpc.o_node_group_subnets
  nodegroup_instance_type = var.v_node_group_instance_type
  nodegroup_disk_size = var.v_node_group_disk_size
  nodegroup_desired_size = var.v_node_group_desired_size
  nodegroup_max_size = var.v_node_group_max_size
  nodegroup_min_size = var.v_node_group_min_size
  ssh_key = var.v_ssh_key_pair
  bastion_sg = module.ec2.o_bastion_sg
  # eks_addons = var.v_eks_addons
}