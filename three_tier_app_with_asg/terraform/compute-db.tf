resource "aws_db_subnet_group" "app_db_subnet_group" {
  name       = "app_db_sub_group"
  subnet_ids = [aws_subnet.dev-vpc-db_server-priv-subnet-1.id, aws_subnet.dev-vpc-db_server-priv-subnet-2.id]

  tags = {
    Name = "app_db_subnet_group"
  }
}

resource "aws_db_instance" "appdb" {
  identifier = "app-db"
  allocated_storage    = 10
  db_name              = var.db_name
  engine               = "mysql"
  engine_version       = "8.0.35"
  instance_class       = "db.t3.micro"
  username             = var.db_user
  password             = var.db_password
  vpc_security_group_ids = [aws_security_group.database_sg.id]
  db_subnet_group_name = aws_db_subnet_group.app_db_subnet_group.name
  skip_final_snapshot  = true

  tags = { 
    Name = "appdb"
  }
}