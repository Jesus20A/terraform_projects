data "aws_ami" "amazon" {
  most_recent = true
  owners = ["137112412989"] # Amazon

  filter {
    name   = "name"
    values = ["al2023-ami-2023*x86_64*"]
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

data "aws_ami" "app" {
  most_recent = true
  owners = ["150755576062"] # me

  filter {
    name   = "name"
    values = ["pkr-app-v*"]
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

data "aws_instances" "web-servers" {
  instance_tags = {
    Name = "web-server"
    Env = "dev"
  }
  depends_on = [ aws_autoscaling_group.app-autoscale ]
}

resource "local_file" "web-servers-inventory" {
  content  = templatefile("./templates/inventory.tpl",
    {
      web_servers = data.aws_instances.web-servers.public_ips
    }
  )
  filename = "../../packer/provisioning/ansible/inventory"
  depends_on = [ data.aws_instances.web-servers ]
}

data "aws_subnets" "web-servers-subnets" {
  filter {
    name = "vpc-id"
    values = [aws_vpc.dev-vpc.id] 
  }
  tags = {
    Name = "web-server-sub"
    Tier = "public"
  }
  depends_on = [ aws_subnet.dev-vpc-web_server-pub-subnet-1, aws_subnet.dev-vpc-web_server-pub-subnet-2 ]
}

data "aws_iam_policy" "SSM-policy" {
  name = "AmazonSSMReadOnlyAccess"
}

data "aws_db_instance" "db" {
  db_instance_identifier = aws_db_instance.appdb.identifier
  tags =  {
    Name = "appdb"
  }
  depends_on = [ aws_db_instance.appdb ]
}

data "aws_lb" "web_lb" {
  arn  = aws_lb.web_server_alb.arn
  tags = {
    Name = "web_servers_load_balancer"
    Env = "dev"
  }
  depends_on = [ aws_lb.web_server_alb ]
}

data "template_file" "app-template-file" {
  template = "${file("./templates/userdata-web.tpl")}"
  vars = {
    app_lb_addr = data.aws_lb.web_lb.dns_name
  }
  depends_on = [ aws_lb.web_server_alb ]
}