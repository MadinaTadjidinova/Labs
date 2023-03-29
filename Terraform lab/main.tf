# 5) Deploy and attach internet Gateway to subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Public"
  }
}

resource "aws_route_table_association" "subnet1" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "subnet2" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.public.id
}

# 6) Deploy 2 EC2 (Amazon Linux2/Ubuntu) on each subnet for the Ansible topic below
resource "tls_private_key" "tls_connector" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "terraform_ec2_key" {
  key_name   = var.key_pair_name
  public_key = tls_private_key.tls_connector.public_key_openssh

  tags = {
    Owner = "madina"
  }
}
resource "local_file" "terraform_ec2_key_file" {
  content  = tls_private_key.tls_connector.private_key_pem
  filename = "terraform_ec2_key.pem"

  provisioner "local-exec" {
    command = "chmod 400 terraform_ec2_key.pem"
  }
}

resource "aws_instance" "amazon-linux-2" {
  ami                    = "ami-024fc608af8f886bc" # Amazon Linux 2
  key_name      = aws_key_pair.terraform_ec2_key.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.subnet2.id 
  security_groups = [aws_security_group.allow_ssh_and_http.id]
  associate_public_ip_address = true
  tags = {
    Name = "Amazon Linux2"
  }
}

resource "aws_instance" "ubuntu-2" {
  ami                    = "ami-024fc608af8f886bc" # Ubuntu 20.04
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.subnet2.id
  key_name      = aws_key_pair.terraform_ec2_key.id
  security_groups = [aws_security_group.allow_ssh_and_http.id]
  tags = {
    Name = "Ubuntu"
  }
}