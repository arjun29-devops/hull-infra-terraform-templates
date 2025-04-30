locals {

  # security group mapping

  security-group-map = {

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
        protocol    = "tcp"
        cidr_blocks = ["10.30.0.0/16"]
      },
      {
        type        = "egress"
        from_port   = -1
        to_port     = -1
        protocol    = "all"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]

    Admin-SG = [
      {
        type        = "ingress"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["10.30.0.0/16"]
      },
      {
        type        = "egress"
        from_port   = -1
        to_port     = -1
        protocol    = "all"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]

    Receive-SG = [
      {
        type        = "ingress"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["10.30.0.0/16"]
      },
      {
        type        = "ingress"
        from_port   = 993
        to_port     = 993
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

    PkgTrans-SG = [
      {
        type        = "ingress"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["10.30.0.0/16"]
      },
      {
        type        = "ingress"
        from_port   = 25
        to_port     = 25
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

    PkgCreate-SG = [
      {
        type        = "ingress"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["10.30.0.0/16"]
      },
      {
        type        = "egress"
        from_port   = -1
        to_port     = -1
        protocol    = "all"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]

    Event-SG = [
      {
        type        = "ingress"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["10.30.0.0/16"]
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