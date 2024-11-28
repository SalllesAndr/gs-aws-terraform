
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "MyTerraformVPC"
  }
}

resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a" 
  tags = {
    Name = "MyTerraformSubnet"
  }
}


resource "aws_security_group" "ssh_access" {
  name   = "allow_ssh"
  vpc_id = aws_vpc.main.id
}


resource "aws_vpc_security_group_ingress_rule" "allow_ssh_access_ipv4" {
  security_group_id = aws_security_group.ssh_access.id
  cidr_ipv4         = "0.0.0.0/0" 
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

# Regras de Saída do Security Group
resource "aws_vpc_security_group_egress_rule" "ssh_access" {
  security_group_id = aws_security_group.ssh_access.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 0
  ip_protocol       = "-1" 
  to_port           = 0
}


resource "aws_instance" "ec2_instance" {
  ami           = "ami-0866a3c8686eaeeba"
  instance_type = var.instance_type
  key_name      = var.key_name

  subnet_id              = aws_subnet.main.id 
  vpc_security_group_ids = [aws_security_group.ssh_access.id]

  tags = {
    Name = "MyEC2Instance"
  }
}
