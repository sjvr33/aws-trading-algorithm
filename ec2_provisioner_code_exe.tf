/* # commented out because of VPN blocking connection to ec2 host
provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo wget https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm",
      "sudo yum localinstall mysql57-community-release-el7-11.noarch.rpm",
      "sudo yum install mysql-community-server",
      "systemctl start mysqld.service"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      host        = self.public_ip
      private_key = file("C:/Users/CP363767/.ssh/${var.bastion_host_key_pair_name}.pem")
    }
  }

  tags = {
    Name = "bastion-host-ec2-connect-ssh"
  }
} # the above block should be inside of ec2 creation block
// Output the ssh command for quick access
output "ssh_cmd" {
  value = "ssh -i C:/Users/CP363767/.ssh/${var.bastion_host_key_pair_name}.pem ec2-user@${aws_instance.ec2_bastion_host.public_ip}"
}
*/
