


# IAM Role

resource "aws_iam_role" "role" {
  name = "${ var.project_name }-${ var.role_name }-${var.env}"
  assume_role_policy = data.template_file.assume_role_policy.rendered

  tags = {
    Name        = "${var.project_name }-${var.env}"
    ProjectName = var.project_name
    CreatedBy = var.created_by
  }
}

resource "aws_iam_role_policy" "policy" {
  name = "${var.project_name }-policy-${var.env}"
  role = aws_iam_role.role.id
  policy = data.aws_iam_policy_document.permissions.json
}

data "template_file" "assume_role_policy" {
  template = file("${ path.module }/assume_role_policy.json")
  vars = {
    assuming_service = var.assuming_role_service
  }
}

data "aws_iam_policy_document" "permissions" {
  statement {
    sid = ""

    actions = compact(concat([
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams",
      "ecr:*"
    ], var.additional_permissions))

    effect = "Allow"

    resources = [
      "*",
    ]
  }
}
