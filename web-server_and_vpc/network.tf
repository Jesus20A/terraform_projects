resource "aws_vpc" "dev-vpc" {
  cidr_block           = "10.123.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "dev"
  }
}

resource "aws_subnet" "dev-vpc-public-subnet-1" {
  vpc_id                  = aws_vpc.dev-vpc.id
  cidr_block              = "10.123.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = {
    Name = "dev-public-1"
  }
}

resource "aws_internet_gateway" "dev-vpc-igw" {
  vpc_id = aws_vpc.dev-vpc.id
  tags = {
    Name = "dev-igw"
  }
}

resource "aws_route_table" "dev-public-rt" {
    vpc_id = aws_vpc.dev-vpc.id
    tags = {
      Name = "dev-public-rt"
    }
}

resource "aws_route" "default-route" {
    route_table_id = aws_route_table.dev-public-rt.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev-vpc-igw.id
}

resource "aws_route_table_association" "dev-public-assoc" {
    subnet_id = aws_subnet.dev-vpc-public-subnet-1.id
    route_table_id = aws_route_table.dev-public-rt.id
}