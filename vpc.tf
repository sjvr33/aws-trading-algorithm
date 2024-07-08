resource "aws_vpc" "mtc_vpc" {
  cidr_block           = var.vpc-cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags = {
    name = "dev"
  }
}


resource "aws_subnet" "mtc_public_subnet" {
  vpc_id                  = aws_vpc.mtc_vpc.id
  cidr_block              = var.public-subnet-cidr
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    name = "dev-public"
  }
}

#Create Private Subnet 1 
# terraform aws create subnet
resource "aws_subnet" "mtc_private_subnet-1" {
  vpc_id                  = aws_vpc.mtc_vpc.id
  cidr_block              = var.private-subnet-1-cidr
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = false

  tags = {
    name = "private subnet 1 | database tier"
  }
}

#Create Private Subnet 2
# terraform aws create subnet
resource "aws_subnet" "mtc_private_subnet-2" {
  vpc_id                  = aws_vpc.mtc_vpc.id
  cidr_block              = var.private-subnet-2-cidr
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = false

  tags = {
    name = "private subnet 2 | database tier"
  }
}


resource "aws_internet_gateway" "mtc_internet_gateway" {
  vpc_id = aws_vpc.mtc_vpc.id

  tags = {
    name = "dev-igw"
  }
}
#already added the below in route-table.tf
# resource "aws_route_table" "mtc_public_rt" {
#   vpc_id = aws_vpc.mtc_vpc.id
# 
#   tags = {
#     name = "dev_puplic_rt"
#   }
# }
# 
# resource "aws_route" "default_route" {
#   route_table_id         = aws_route_table.mtc_public_rt.id
#   destination_cidr_block = "0.0.0.0/0"
#   gateway_id             = aws_internet_gateway.mtc_internet_gateway.id
# }
# 
# resource "aws_route_table_association" "mtc_public_asset" {
#   subnet_id      = aws_subnet.mtc_public_subnet.id
#   route_table_id = aws_route_table.mtc_public_rt.id
# }


// NAT gateway requires an elastic ip
resource "aws_eip" "aws_eip_public" {
  tags = {
    name = "AWS Elastic IP resource"
  }
}

resource "aws_nat_gateway" "aws_nat_gateway_public" {
  allocation_id = aws_eip.aws_eip_public.id
  // connect to public subnet
  subnet_id = aws_subnet.mtc_public_subnet.id
  tags = {
    Name = "aws nat gateway"
  }
}
