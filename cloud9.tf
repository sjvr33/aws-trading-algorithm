#resource "aws_cloud9_environment_ec2" "cloud9_ec2" {
#  instance_type               = "t2.micro"
#  name                        = "cloud9_ec2"
#  subnet_id                   = aws_subnet.mtc_public_subnet.id
#  automatic_stop_time_minutes = 30
#  connection_type             = "CONNECT_SSM"
#}
#
#data "aws_instance" "cloud9_instance" {
#  filter {
#    name = "tag:aws:cloud9:environment"
#    values = [
#    aws_cloud9_environment_ec2.cloud9_ec2.id]
#  }
#}
#
#resource "aws_eip" "cloud9_eip" {
#  instance = data.aws_instance.cloud9_instance.id
#  vpc      = true
#}
#
#output "cloud9_public_ip" {
#  value = aws_eip.cloud9_eip.public_ip
#}
#
#resource "aws_iam_user" "cloud9_user" {
#  name = "some-user"
#}
#
#resource "aws_cloud9_environment_membership" "test" {
#  environment_id = aws_cloud9_environment_ec2.cloud9_ec2.id
#  permissions    = "read-write"
#  user_arn       = aws_iam_user.cloud9_user.arn
#}
