# 2) Deploy VPC. CIDR block is 192.168.0.0/16 
resource "aws_vpc" "vpc1" {
  cidr_block = "192.168.0.0/16"
  tags = {
    Name = "CustomVPC"
           }
}