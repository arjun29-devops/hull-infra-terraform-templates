
# create VPC
resource "aws_vpc" "vpc" {
  cidr_block           = local.vpc["cidr_block"]
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.ProjectName}-vpc-${var.env}"
    ProjectName = var.ProjectName
    CreatedBy   = var.CreatedBy
  }
}

# create subnets

resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = local.pri_sub_1_cidr["cidr_block"]
  availability_zone = "ap-south-1a"
  tags = {
    Name        = "${var.ProjectName}-pri-subnet-1"
    ProjectName = var.ProjectName
    CreatedBy   = var.CreatedBy
  }

  depends_on = [
    aws_vpc.vpc
  ]
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = local.pri_sub_2_cidr["cidr_block"]
  availability_zone = "ap-south-1b"
  tags = {
    Name        = "${var.ProjectName}-pri-subnet-2"
    ProjectName = var.ProjectName
    CreatedBy   = var.CreatedBy
  }
  depends_on = [
    aws_vpc.vpc
  ]
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = local.pub_sub_1_cidr["cidr_block"]
  availability_zone = "ap-south-1a"
  tags = {
    Name        = "${var.ProjectName}-pub-subnet-1"
    ProjectName = var.ProjectName
    CreatedBy   = var.CreatedBy
  }
  depends_on = [
    aws_vpc.vpc
  ]
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = local.pub_sub_2_cidr["cidr_block"]
  availability_zone = "ap-south-1b"
  tags = {
    Name        = "${var.ProjectName}-pub-subnet-2"
    ProjectName = var.ProjectName
    CreatedBy   = var.CreatedBy
  }
  depends_on = [
    aws_vpc.vpc
  ]
}

# associate the subnets to the route table

resource "aws_route_table_association" "rt-tbl-association-private-1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.rt-tbl-private.id
  depends_on = [
    aws_subnet.private_subnet_1,
    aws_route_table.rt-tbl-private
  ]
}

resource "aws_route_table_association" "rt-tbl-association-public-1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.rt-tbl-public.id
  depends_on = [
    aws_subnet.public_subnet_1,
    aws_route_table.rt-tbl-public
  ]
}

resource "aws_route_table_association" "rt-tbl-association-private-2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.rt-tbl-private.id
  depends_on = [
    aws_subnet.private_subnet_2,
    aws_route_table.rt-tbl-private
  ]
}

resource "aws_route_table_association" "rt-tbl-association-public-2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.rt-tbl-public.id
  depends_on = [
    aws_subnet.public_subnet_2,
    aws_route_table.rt-tbl-public
  ]
}

# create internet gateway for VPC

resource "aws_internet_gateway" "int-gtwy" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name        = "${var.ProjectName}-igw-${var.env}"
    ProjectName = var.ProjectName
    CreatedBy   = var.CreatedBy
  }
  depends_on = [
    aws_vpc.vpc
  ]
}

### NAT GATEWAY

# create elastic IP for NAT gateway

resource "aws_eip" "nat-eip" {
  vpc = true
  tags = {
    Name        = "${var.ProjectName}-nat-eip-${var.env}"
    ProjectName = var.ProjectName
    CreatedBy   = var.CreatedBy
  }
}

# create NAT gateway
# Note : Added only one subnet

resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.nat-eip.id
  subnet_id     = aws_subnet.public_subnet_1.id

  tags = {
    Name        = "${var.ProjectName}-ngw-${var.env}"
    ProjectName = var.ProjectName
    CreatedBy   = var.CreatedBy
  }
}

### ROUTE TABLE

# create public route table

resource "aws_route_table" "rt-tbl-public" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.int-gtwy.id
  }
  tags = {
    Name        = "${var.ProjectName}-rt-public-${var.env}"
    ProjectName = var.ProjectName
    CreatedBy   = var.CreatedBy
  }
  depends_on = [
    aws_vpc.vpc
  ]
}

# create private route table

resource "aws_route_table" "rt-tbl-private" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw.id
  }
  tags = {
    Name        = "${var.ProjectName}-rt-private-${var.env}"
    ProjectName = var.ProjectName
    CreatedBy   = var.CreatedBy
  }
  depends_on = [
    aws_vpc.vpc
  ]
}

# allow all ingress and egress for ACL

resource "aws_default_network_acl" "acl-default" {
  default_network_acl_id = aws_vpc.vpc.default_network_acl_id

  subnet_ids = [aws_subnet.private_subnet_2.id, aws_subnet.private_subnet_1.id]

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name        = "${var.ProjectName}-acl-default-${var.env}"
    ProjectName = var.ProjectName
    CreatedBy   = var.CreatedBy
  }
}

resource "aws_network_acl" "acl-public" {
  vpc_id     = aws_vpc.vpc.id
  subnet_ids = [aws_subnet.public_subnet_2.id, aws_subnet.public_subnet_1.id]

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name        = "${var.ProjectName}-acl-public-${var.env}"
    ProjectName = var.ProjectName
    CreatedBy   = var.CreatedBy
  }
}

### SECURITY GROUPS

# create security groups

resource "aws_security_group" "sec-grps" {
  for_each = local.security-group-map
  name     = "${var.ProjectName}-sg-${each.key}"
  vpc_id   = aws_vpc.vpc.id
  tags = {
    Name        = "${var.ProjectName}-sg-${each.key}-${var.env}"
    ProjectName = var.ProjectName
    CreatedBy   = var.CreatedBy
  }
  depends_on = [
    aws_vpc.vpc
  ]
}

# create rules for the security groups

resource "aws_security_group_rule" "sec-grp-rules" {
  for_each          = local.security-group-rules
  security_group_id = aws_security_group.sec-grps[each.value.resource].id
  type              = each.value.type
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = lookup(each.value, "cidr_blocks", null)
  source_security_group_id = lookup(
    each.value, "source_security_group_id", null
    ) == null ? null : aws_security_group.sec-grps[
    lookup(each.value, "source_security_group_id", null)
  ].id
}
