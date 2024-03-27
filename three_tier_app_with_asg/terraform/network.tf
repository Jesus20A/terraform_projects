################################# VPC ##########################################

resource "aws_vpc" "dev-vpc" {
  cidr_block           = "10.123.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "dev-vpc"
  }
}

############################### Subnets #######################################

resource "aws_subnet" "dev-vpc-web_server-pub-subnet-1" {
  vpc_id                  = aws_vpc.dev-vpc.id
  cidr_block              = "10.123.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = {
    Name = "web-server-sub"
    Tier = "public"
  }
}

resource "aws_subnet" "dev-vpc-web_server-pub-subnet-2" {
  vpc_id                  = aws_vpc.dev-vpc.id
  cidr_block              = "10.123.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b"
  tags = {
    Name = "web-server-sub"
    Tier = "public"
  }
}
resource "aws_subnet" "dev-vpc-db_server-priv-subnet-1" {
  vpc_id                  = aws_vpc.dev-vpc.id
  cidr_block              = "10.123.5.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = {
    Name = "db-server-sub"
    Tier = "private"
  }
}
resource "aws_subnet" "dev-vpc-db_server-priv-subnet-2" {
  vpc_id                  = aws_vpc.dev-vpc.id
  cidr_block              = "10.123.6.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b"
  tags = {
    Name = "db-server-sub"
    Tier = "private"
  }
}


############################### IGW #############################################

resource "aws_internet_gateway" "dev-vpc-igw" {
  vpc_id = aws_vpc.dev-vpc.id
  tags = {
    Name = "dev-igw"
  }

}

############################################################################50
resource "aws_route_table" "public-rt" {
    vpc_id = aws_vpc.dev-vpc.id
    tags = {
      Name = "public-rt"
    }
}
resource "aws_route" "public-rf-route" {
    route_table_id = aws_route_table.public-rt.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev-vpc-igw.id
}
resource "aws_route_table_association" "dev-public-assoc-sub-1" {
    subnet_id = aws_subnet.dev-vpc-web_server-pub-subnet-1.id
    route_table_id = aws_route_table.public-rt.id
  
}
resource "aws_route_table_association" "dev-public-assoc-sub-2" {
    subnet_id = aws_subnet.dev-vpc-web_server-pub-subnet-2.id
    route_table_id = aws_route_table.public-rt.id
  
}
############################################################################50

resource "aws_route_table" "private-rt" {
    vpc_id = aws_vpc.dev-vpc.id
    tags = {
      Name = "private-rt"
    }
}
resource "aws_route_table_association" "dev-private-assoc-db-1" {
    subnet_id = aws_subnet.dev-vpc-db_server-priv-subnet-1.id
    route_table_id = aws_route_table.private-rt.id
}
resource "aws_route_table_association" "dev-private-assoc-db-2" {
    subnet_id = aws_subnet.dev-vpc-db_server-priv-subnet-2.id
    route_table_id = aws_route_table.private-rt.id
}