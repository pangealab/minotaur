#
# VPC Resources
#  * VPC
#  * Subnets
#  * Internet Gateway
#  * Route Table
#

resource "aws_vpc" "loom" {
  cidr_block = "13.0.0.0/16"
  tags = map(
    "Name", "Loom VPC",
  )
}

resource "aws_subnet" "loom" {
  availability_zone = "${data.aws_availability_zones.azs.names[0]}"
  cidr_block        = "13.0.0.0/24"
  vpc_id            = aws_vpc.loom.id
  map_public_ip_on_launch = "true"
  tags = map(
    "Name", "Loom Subnet",
  )
}

resource "aws_internet_gateway" "loom" {
  vpc_id = aws_vpc.loom.id
  tags = {
    Name = "Loom IGW"
  }
}

resource "aws_route_table" "loom" {
  vpc_id = aws_vpc.loom.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.loom.id
  }
}

resource "aws_route_table_association" "loom" {
  subnet_id      = aws_subnet.loom.id
  route_table_id = aws_route_table.loom.id
}