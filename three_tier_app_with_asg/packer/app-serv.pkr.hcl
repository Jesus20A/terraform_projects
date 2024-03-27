packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1.1.1"
    }
  }
}

data "amazon-ami" "amazon" {
  most_recent = true
  owners = ["137112412989"] # Amazon

  filters = {
        virtualization-type = "hvm"
        name = "al2023-ami-2023*x86_64*"
        root-device-type = "ebs"
    }
}


source "amazon-ebs" "packerami" {

    region = "us-east-1"
    ami_name = "pkr-app-v1.0-{{timestamp}}"
    source_ami = data.amazon-ami.amazon.id
    instance_type = "t2.micro"
    subnet_id = "subnet-03ca18fd00ed807f4"
    ssh_username = "ec2-user"
    tags = {
        OS_Version = "Amazon Linux 2023"
        Release = "latest"
        Name = "pkr-app-v1.0"
    }
}

build {

    sources = ["source.amazon-ebs.packerami"]
    
    provisioner "file" {
      source = "./packer/provisioning/shell/app.tar.gz"
      destination = "/home/ec2-user/"
    }
    provisioner "file" {
      source = "./packer/provisioning/shell/app.service"
      destination = "/home/ec2-user/app.service"
    }
    provisioner "shell" {
      script = "./packer/provisioning/shell/app.sh"
    }
}
