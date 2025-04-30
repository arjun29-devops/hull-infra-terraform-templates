# Create DB subnet Group

resource "aws_db_subnet_group" "db_subnets" {
  name       = "private-subnets"
  subnet_ids = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
  tags = {
    Name        = "db-subnets-privates"
    ProjectName = var.ProjectName
    CreatedBy   = var.CreatedBy
  }
}

# DB parameter Group Name

resource "aws_db_parameter_group" "db_parameter_group" {
  name   = "postgres-pg"
  family = "postgres11"
}

# DB instance - RDS postgres

resource "aws_db_instance" "db_instance" {
  allocated_storage = 40
  identifier        = "communication-svc-rds-${var.env}"
  storage_type      = "gp2"
  engine            = "postgres"
  engine_version    = "11.8"
  #instance_class       = "db.t3.medium"
  instance_class         = "db.t3.micro"
  name                   = "synergydb${var.env}"
  username               = var.rds_username
  password               = var.rds_password
  parameter_group_name   = aws_db_parameter_group.db_parameter_group.name
  port                   = "5432"
  deletion_protection    = true
  db_subnet_group_name   = aws_db_subnet_group.db_subnets.name
  vpc_security_group_ids = [aws_security_group.sec-grps["DB-SG"].id]
  depends_on = [
    aws_db_parameter_group.db_parameter_group,
    aws_db_subnet_group.db_subnets
  ]
}
