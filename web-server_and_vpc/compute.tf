resource "aws_instance" "web-server" {
  ami           = data.aws_ami.amazon.id
  instance_type = "t2.micro"
  key_name = "abdias-key"
  subnet_id = aws_subnet.dev-vpc-public-subnet-1.id
  vpc_security_group_ids = [aws_security_group.allow_http.id]
  user_data = file("userdata.tpl")

  tags = {
    Name = "web-server"
  }
}