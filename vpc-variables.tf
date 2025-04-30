locals {
  # VPC configuration

  vpc = {
    cidr_block = "10.10.0.0/16"
  }

  pri_sub_1_cidr = {
    cidr_block = "10.10.1.0/24"
  }

  pri_sub_2_cidr = {
    cidr_block = "10.10.3.0/24"
  }

  pub_sub_1_cidr = {
    cidr_block = "10.10.2.0/24"
  }

  pub_sub_2_cidr = {
    cidr_block = "10.10.4.0/24"
  }

  # subnet mapping

  /* subnet-map = {
    private_subnet = [
      {
        cidr_block        = "10.10.1.0/24"
        availability_zone = "ap-south-1a"
      },
      {
        cidr_block        = "10.10.3.0/24"
        availability_zone = "ap-south-1b"
      }
    ]
    public_subnet = [
      {
        cidr_block        = "10.10.2.0/24"
        availability_zone = "ap-south-1a"
      },
      {
        cidr_block        = "10.10.4.0/24"
        availability_zone = "ap-south-1b"
      }
    ]
  }

  _subnets = flatten([
    for name, subnets in local.subnet-map : [
      for ix, sn in subnets : {
        resource          = name
        cidr_block        = sn.cidr_block
        availability_zone = sn.availability_zone
      }
    ]
  ])

  subnets = {
    for sn in local._subnets : "sbnt-${sn.resource}-${sn.availability_zone}" => {
      cidr_block        = sn.cidr_block
      availability_zone = sn.availability_zone
    }
  }
  */

  # security group mapping

  security-group-map = {
    bastionHost-SG = [
      {
        type        = "ingress"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        type        = "egress"
        from_port   = -1
        to_port     = -1
        protocol    = "all"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]

    Alb-SG = [
      {
        type        = "ingress"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        type        = "ingress"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        type        = "egress"
        from_port   = -1
        to_port     = -1
        protocol    = "all"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]

    DB-SG = [
      {
        type        = "ingress"
        from_port   = 5432
        to_port     = 5432
        protocol    = "all"
        cidr_blocks = ["10.10.0.0/16"]
      },
      {
        type        = "egress"
        from_port   = -1
        to_port     = -1
        protocol    = "all"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  }

  _security-group-rules = flatten([
    for resource, rules in local.security-group-map : [
      for ix, sgr in rules : {
        hash                  = base64encode(jsonencode(sgr))
        resource              = resource
        type                  = lookup(sgr, "type", null)
        from_port             = lookup(sgr, "from_port", null)
        to_port               = lookup(sgr, "to_port", null)
        protocol              = lookup(sgr, "protocol", null)
        cidr_blocks           = lookup(sgr, "cidr_blocks", null)
        source_security_group = lookup(sgr, "source_security_group", null)
      }
    ]
  ])

  security-group-rules = {
    for ix, sgr in local._security-group-rules : "sg-rule-${sgr.resource}-${sgr.hash}" => {
      resource                 = sgr.resource
      type                     = sgr.type
      from_port                = sgr.from_port
      to_port                  = sgr.to_port
      protocol                 = sgr.protocol
      cidr_blocks              = sgr.cidr_blocks
      source_security_group_id = sgr.source_security_group
    }
  }

}
