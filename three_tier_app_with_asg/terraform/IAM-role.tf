resource "aws_iam_role" "app-ssm-role" {
  name = "app-ssm-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "app-ssm-policy-attachment" {
  role       = aws_iam_role.app-ssm-role.name
  policy_arn = data.aws_iam_policy.SSM-policy.arn
}

resource "aws_iam_instance_profile" "app-server-instance-profile" {
  name = "app-server-instance-profile"
  role = aws_iam_role.app-ssm-role.name
}