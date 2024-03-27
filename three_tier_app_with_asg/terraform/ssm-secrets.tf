resource "aws_ssm_parameter" "app_key" {
  name        = "SECRET_KEY"
  description = "Flask app key"
  type        = "SecureString"
  value       = var.app_key
  tier        = "Standard"

  tags = {
    Name        = "app-key"
    Env         = "dev"
  }
}
resource "aws_ssm_parameter" "db_host" {
  name        = "MYSQL_HOST"
  description = "Database host"
  type        = "SecureString"
  value       = data.aws_db_instance.db.address
  tier        = "Standard"

  tags = {
    Name        = "db-host"
    Env         = "dev"
  }
  depends_on = [ data.aws_db_instance.db ]
}
resource "aws_ssm_parameter" "db_user" {
  name        = "MYSQL_USER"
  description = "Database user"
  type        = "SecureString"
  value       = var.db_user
  tier        = "Standard"

  tags = {
    Name        = "db-user"
    Env         = "dev"
  }
}
resource "aws_ssm_parameter" "db_password" {
  name        = "MYSQL_PASSWORD"
  description = "Database password"
  type        = "SecureString"
  value       = var.db_password

  tags = {
    Name        = "db-password"
    environment = "dev"
  }
}
resource "aws_ssm_parameter" "db_name" {
  name        = "MYSQL_DB"
  description = "Database name"
  type        = "SecureString"
  value       = var.db_name
  tier        = "Standard"

  tags = {
    Name        = "db-name"
    environment = "dev"
  }
}