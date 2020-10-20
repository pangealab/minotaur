#
# VPC Resources
#  * VPC
#  * Subnets
#  * Internet Gateway
#  * Route Table
#

resource "aws_vpc" "loom" {
  cidr_block = "13.0.0.0/16"
  tags = merge(
    local.common_tags,
    map(
      "Name", "Loom VPC"
    )
  )  
}

resource "aws_subnet" "loom" {
  availability_zone = data.aws_availability_zones.azs.names[0]
  cidr_block        = "13.0.0.0/24"
  vpc_id            = aws_vpc.loom.id
  map_public_ip_on_launch = "true"
  tags = merge(
    local.common_tags,
    map(
      "Name", "Loom Subnet"
    )
  )
}

resource "aws_internet_gateway" "loom" {
  vpc_id = aws_vpc.loom.id
  tags = merge(
    local.common_tags,
    map(
      "Name", "Loom IGW"
    )
  )
}

resource "aws_route_table" "loom" {
  vpc_id = aws_vpc.loom.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.loom.id
  }
  tags = merge(
    local.common_tags,
    map(
      "Name", "Loom Route Table"
    )
  )
}

resource "aws_route_table_association" "loom" {
  subnet_id      = aws_subnet.loom.id
  route_table_id = aws_route_table.loom.id
}

#
# VPC Configuration
#

resource "aws_security_group" "loom-security-group" {
  name        = "Loom Security Group"
  description = "Loom Security Group"
  vpc_id      = aws_vpc.loom.id
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(
    local.common_tags,
    map(
      "Name", "Loom Security Group"
    )
  )
}