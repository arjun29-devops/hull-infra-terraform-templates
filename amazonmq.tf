resource "aws_mq_configuration" "mq_config" {
  description    = "Communication Service Configuration"
  name           = "${var.ProjectName}-mq-config-${var.env}"
  engine_type    = "ActiveMQ"
  engine_version = "5.15.0"

  data = <<DATA
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<broker xmlns="http://activemq.apache.org/schema/core">
  <plugins>
    <forcePersistencyModeBrokerPlugin persistenceFlag="true"/>
    <statisticsBrokerPlugin/>
    <timeStampingBrokerPlugin ttlCeiling="86400000" zeroExpirationOverride="86400000"/>
  </plugins>
</broker>
DATA
}

# ActiveMQ SG
resource "aws_security_group" "mq_sg" {
  name   = "${var.ProjectName}-mq-sg-${var.env}"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 5671
    to_port     = 5671
    protocol    = "tcp"
    cidr_blocks = ["10.10.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.ProjectName}-mq-sg-${var.env}"
    ProjectName = var.ProjectName
    CreatedBy   = var.CreatedBy
  }
}


resource "aws_mq_broker" "mq_broker" {
  broker_name = "${var.ProjectName}-mq-${var.env}"

  configuration {
    id       = aws_mq_configuration.mq_config.id
    revision = aws_mq_configuration.mq_config.latest_revision
  }

  engine_type                = "ActiveMQ"
  engine_version             = "5.15.0"
  host_instance_type         = "mq.t2.micro"
  security_groups            = [aws_security_group.mq_sg.id]
  apply_immediately          = true
  auto_minor_version_upgrade = false
  deployment_mode            = "SINGLE_INSTANCE"
  publicly_accessible        = false
  subnet_ids                 = [aws_subnet.private_subnet_1.id]



  user {
    username = "synergy"
    password = "CjMZ3Rp8JUMn8wcg"
  }
}
