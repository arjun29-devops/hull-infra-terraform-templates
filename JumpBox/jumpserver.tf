# IAM profile for ec2
resource "aws_iam_instance_profile" "ec2-jump-iam-profile" {
  name = "ec2-jump-iam-profile"
  role = aws_iam_role.jump-ec2-role.name
}

# Creating Jump Server ec2
resource "aws_instance" "jump_vm" {
  ami                         = var.ami
  instance_type               = var.instance_type
  disable_api_termination     = "true"
  vpc_security_group_ids      = var.bastion_security_group
  key_name                    = var.key_name
  iam_instance_profile        = aws_iam_instance_profile.ec2-jump-iam-profile.name
  subnet_id                   = var.bastion_subnets
  associate_public_ip_address = "true"
  tags = {
    Name        = "${var.ProjectName}-bastion-${var.env}"
    ProjectName = var.ProjectName
    CreatedBy   = var.CreatedBy
  }
}
