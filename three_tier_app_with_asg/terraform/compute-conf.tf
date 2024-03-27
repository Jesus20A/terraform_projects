resource "aws_instance" "conf-server" {
  ami           = data.aws_ami.amazon.id
  instance_type = "t2.micro"
  key_name      = "conf-key"
  subnet_id     = aws_subnet.dev-vpc-web_server-pub-subnet-1.id
  vpc_security_group_ids = [aws_security_group.conf_server_sg.id]
  user_data     = templatefile("./templates/userdata-conf.tpl",
    {
      db_user = var.db_user
      db_password = var.db_password
      db_host = data.aws_db_instance.db.address
    }
  )

  depends_on = [ data.aws_db_instance.db ]

  tags = {
    Name = "conf-server"
    Env = "dev"
  }
}
