// Find the latest default amazon AMI
#data "aws_ami" "amazon_linux_2" {
#  most_recent = true
#  owners      = ["amazon"]
#  filter {
#    name   = "name"
#    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
#  }
#}

# Get latest Windows Server 2019 AMI
#data "aws_ami" "windows_2019" {
#  most_recent = true
#  owners      = ["amazon"]
#  filter {
#    name   = "name"
#    values = ["Windows_Server-2019-English-Full-Base*"]
#  }
#}

// Create a small instance to be able to tunnel
// to the database, run migrations, etc
resource "aws_instance" "ec2_bastion_host" {
  ami                         = "ami-010a9d7d81c612c3f"
  instance_type               = "t3.small"
  vpc_security_group_ids      = [aws_security_group.ssh.id]
  subnet_id                   = aws_subnet.mtc_public_subnet.id
  associate_public_ip_address = true
  // For the key pair, we could use terraform
  // to generate it, but I've chosen to just
  // create it via the AWS console.
  //
  // Make sure it's a key pair name from the same
  // region in vars.tf, i.e. us-east-2
  key_name = var.bastion_host_key_pair_name
  root_block_device {
    volume_type = "gp2"
    volume_size = 100
    encrypted   = true
  }

  tags = {
    Name = "windows-bastion-host"
  }
}




