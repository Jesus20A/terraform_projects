data "aws_ami" "amazon" {
  most_recent = true
  owners = ["137112412989"] # Amazon

  filter {
    name   = "name"
    values = ["al2023-ami-2023.3.20240131.0-kernel-6.1-x86_64*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}