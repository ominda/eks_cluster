resource "aws_instance" "r_public_ec2_instances" {
  count = var.public_ec2_count
  ami           = data.aws_ami.d_ubuntu_amis.id
  instance_type = "t3.micro"
  associate_public_ip_address = true
  key_name = var.ssh_key  
  subnet_id = var.public_subnets[0].id
  vpc_security_group_ids = [aws_security_group.r_public_default_sg.id]
  iam_instance_profile = aws_iam_instance_profile.r_iam_instance_profile.name
  user_data_base64 = base64encode(file("${path.module}/scripts/install_kubernetes.sh"))
  user_data_replace_on_change = true

  tags = {
    Name = format("${local.base_name}-Bastionhost-0%d", count.index + 1)
  }
}