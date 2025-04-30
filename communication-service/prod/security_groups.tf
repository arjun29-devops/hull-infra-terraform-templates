### SECURITY GROUPS

# create security groups

resource "aws_security_group" "sec-grps" {
  for_each = local.security-group-map
  name     = "${var.ProjectName}-sg-${each.key}"
  vpc_id   = var.vpcId
  tags = {
    Name        = "${var.ProjectName}-sg-${each.key}-${var.env}"
    ProjectName = var.ProjectName
    CreatedBy   = var.CreatedBy
  }
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