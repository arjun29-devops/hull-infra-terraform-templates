# Create ECS Cluster

resource "aws_ecs_cluster" "ecs-cluster" {
  name = "${var.ProjectName}-ecs-cluster-${var.env}"
}

# ECS service IAM Role

resource "aws_iam_role" "ecs-service-role" {
  name = "${var.ProjectName}-ecs-service-role-${var.env}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    Name        = "${var.ProjectName}-ecs-service-role-${var.env}"
    ProjectName = var.ProjectName
    CreatedBy   = var.CreatedBy
  }
}

resource "aws_iam_role_policy" "ecs-service-policy" {
  name = "${var.ProjectName}-ecs-service-policy-${var.env}"
  role = aws_iam_role.ecs-service-role.id

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
                  "ec2:*",
                  "elasticloadbalancing:*",
                  "route53:*",
                  "servicediscovery:*",
                  "sts:*",
                  "cloudwatch:*",
                  "ecr:GetAuthorizationToken",
                  "ecr:BatchCheckLayerAvailability",
                  "ecr:BatchGetImage",
                  "ecr:GetDownloadUrlForLayer",
                  "ecr:*",
                  "logs:*",
                  "mq:*"
        ],
        "Effect": "Allow",
        "Resource": "*"
      }
    ]
  }
  EOF
}

# ECS Task IAM Role

resource "aws_iam_role" "ecs-task-role" {
  name = "${var.ProjectName}-ecs-task-role-${var.env}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    Name        = "${var.ProjectName}-ecs-task-role-${var.env}"
    ProjectName = var.ProjectName
    CreatedBy   = var.CreatedBy
  }
}

resource "aws_iam_role_policy" "ecs-task-policy" {
  name = "ecs-task-policy-${var.env}"
  role = aws_iam_role.ecs-task-role.id

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "ecr:*",
          "ecs:*",
          "logs:*",
          "ses:*",
          "cognito-identity:*",
          "cognito-sync:*",
          "s3:*",
          "sns:*",
          "mq:*"
        ],
        "Effect": "Allow",
        "Resource": "*"
      }
    ]
  }
  EOF
}

# ECS Service Autoscalling IAM Role

resource "aws_iam_role" "ecs-autoscalling-role" {
  name = "${var.ProjectName}-ecs-autoscalling-role-${var.env}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "application-autoscaling.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    Name        = "${var.ProjectName}-ecs-autoscalling-role-${var.env}"
    ProjectName = var.ProjectName
    CreatedBy   = var.CreatedBy
  }
}

resource "aws_iam_role_policy" "ecs-autoscalling-policy" {
  name = "ecs-autoscalling-policy-${var.env}"
  role = aws_iam_role.ecs-autoscalling-role.id

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
                  "application-autoscaling:*",
                  "cloudwatch:*",
                  "ecs:*",
                  "ecr:*",
                  "logs:*"
        ],
        "Effect": "Allow",
        "Resource": "*"
      }
    ]
  }
  EOF
}

