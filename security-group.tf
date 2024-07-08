#deprecated
#resource "aws_security_group" "mtc_sg" {
#  name        = "dev_sg"
#  description = "dev_security_group"
#  vpc_id      = aws_vpc.mtc_vpc.id
#
#  ingress {
#    from_port   = 0
#    to_port     = 0
#    protocol    = "-1"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#
#  egress {
#    from_port   = 0
#    to_port     = 0
#    protocol    = "-1"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#}


# create security group for the database
# terraform create security group  
resource "aws_security_group" "database-security-group" {
  name        = "database security group"
  description = "enable mysql access to port 3306"
  vpc_id      = aws_vpc.mtc_vpc.id

  ingress {
    description     = "mysql access"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.lambda.id, aws_security_group.ssh.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "security group for mysql db"
  }
}

# security group for lamda function to be able to connect to internet
resource "aws_security_group" "lambda" {
  vpc_id = aws_vpc.mtc_vpc.id
  name   = "lambda-security-group"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#ssh sg for bastion host 
resource "aws_security_group" "ssh" {
  vpc_id = aws_vpc.mtc_vpc.id
  name   = "bastion-ec-security-group"

  # ssh connection 
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # for window RDP connections from local laptop host
  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #http connection
  #ingress {
  #  from_port   = 5000
  #  to_port     = 5000
  #  protocol    = "tcp"
  #  cidr_blocks = ["0.0.0.0/0"]
  #}

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
