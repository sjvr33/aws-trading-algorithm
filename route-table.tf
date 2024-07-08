resource "aws_route_table" "mtc_route_table_public" {
  vpc_id = aws_vpc.mtc_vpc.id
  tags = {
    name = "route table for public subnet"
  }
}

resource "aws_route_table_association" "mtc_route_table_association_public" {
  route_table_id = aws_route_table.mtc_route_table_public.id
  subnet_id      = aws_subnet.mtc_public_subnet.id
}

resource "aws_route" "mtc_aws_route_public" {
  route_table_id         = aws_route_table.mtc_route_table_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.mtc_internet_gateway.id
}

resource "aws_route_table" "mtc_route_table_private" {
  vpc_id = aws_vpc.mtc_vpc.id
  tags = {
    Name = "route table for private subnet where lamda and rds resides"
  }
}

resource "aws_route" "mtc_aws_route_private" {
  route_table_id         = aws_route_table.mtc_route_table_private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.aws_nat_gateway_public.id
}

resource "aws_route_table_association" "mtc_route_table_association_private-1" {
  route_table_id = aws_route_table.mtc_route_table_private.id
  subnet_id      = aws_subnet.mtc_private_subnet-1.id
}

resource "aws_route_table_association" "mtc_route_table_association_private-2" {
  route_table_id = aws_route_table.mtc_route_table_private.id
  subnet_id      = aws_subnet.mtc_private_subnet-2.id
}
