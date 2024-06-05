output "o_vpc" {
  value = aws_vpc.r_vpc  
}

# Take out the public subnets
output "o_public_subnets" {
    value = aws_subnet.r_public_subnets
}

output "o_public_lb_subnets" {
    value = aws_subnet.r_public_lb_subnets
}

output "o_control_plane_subnets" {
  value = aws_subnet.r_control_plane_subnets
}

output "o_internal_lb_subnets" {
  value = aws_subnet.r_internal_lb_subnets
}

output "o_tgw_subnets" {
  value = aws_subnet.r_tgw_subnets
}

output "o_private_nat_subnets" {
  value = aws_subnet.r_private_nat_subnets
}

output "o_efs_subnets" {
  value = aws_subnet.r_efs_subnets
}

output "o_utility_subnets" {
  value = aws_subnet.r_utility_subnets
}

output "o_db_subnets" {
  value = aws_subnet.r_db_subnets
}

output "o_node_group_subnets" {
  value = aws_subnet.r_node_group_subnets
}