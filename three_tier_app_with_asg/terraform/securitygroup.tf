resource "aws_security_group" "web_servers_sg" {
    name = "web-server-sg"
    description = "Allow http access"
    vpc_id = aws_vpc.dev-vpc.id

    ingress {
        description = "allow http connections"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "allow ssh connections"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        security_groups = [ aws_security_group.conf_server_sg.id ]
    }
    egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    }
    tags = {
      Name = "web_servers_sg"
    }
}

resource "aws_security_group" "database_sg" {
    name = "database_sg"
    description = "Allow 3306 port access"
    vpc_id = aws_vpc.dev-vpc.id

    ingress {
        description = "allow 3306 connections"
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        security_groups = [aws_security_group.web_servers_sg.id, aws_security_group.conf_server_sg.id]
    }       
    egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks = [ aws_vpc.dev-vpc.cidr_block ]
    }
    tags = {
      Name = "database_sg"
    }
}

resource "aws_security_group" "load_balancer_sg" {
    name = "load-balancer-sg"
    description = "Allow http access"
    vpc_id = aws_vpc.dev-vpc.id
    ingress {
        description = "allow http connections"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    }
    tags = {
      Name = "load_balancer_sg"
    }
}




resource "aws_security_group" "conf_server_sg" {
    name = "conf-server-sg"
    description = "Allow ssh access"
    vpc_id = aws_vpc.dev-vpc.id
    ingress {
        description = "allow ssh connections"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    }
    tags = {
      Name = "conf_server_sg"
    }
}