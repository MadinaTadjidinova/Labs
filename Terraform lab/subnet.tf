# 4) Deploy 2 subnets
resource "aws_subnet" "subnet1" {
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = "192.168.1.0/24"

  tags = {
    Name = "Subnet1"
  }
}

resource "aws_subnet" "subnet2" {
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = "192.168.2.0/24"

  tags = {
    Name = "Subnet2"
  }
}
