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
  count = 1
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = "13.0.${count.index}.0/24"
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
  count = 1
  subnet_id      = aws_subnet.loom.*.id[count.index]
  route_table_id = aws_route_table.loom.id
}
