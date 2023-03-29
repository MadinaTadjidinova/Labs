# 3) Deploy Internet gateway
resource "aws_internet_gateway" "igw" { 
vpc_id = aws_vpc.vpc1.id
tags = { Name = "IGW" } 
}