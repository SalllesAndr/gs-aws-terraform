resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "MyTerraformVPC"
  }
}

resource "aws_security_group" "ssh_access" {
  name        = "allow_ssh"
  vpc_id      = aws_vpc.main.id
}
resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = aws_vpc.main.cidr_block
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "ssh_access" {
  security_group_id = aws_security_group.ssh_access.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
  tags = {
    Name = "SSH-Access-SG"
  }
}

resource "aws_instance" "ec2_instance" {
  ami           = "ami-0866a3c8686eaeeba"
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.ssh_access.id]

  tags = {
    Name = "MyEC2Instance"
  }
}
