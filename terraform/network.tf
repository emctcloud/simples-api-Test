resource "aws_vpc" "ecs-vpc" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(
    local.tags, {
      Name = "${var.project_name}-VPC"
    }
  )
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.ecs-vpc.id
  tags = merge(
    local.tags, {
      Name = "${var.project_name}-IGW"
    }
  )
}
resource "aws_subnet" "ecs_sub_priv_1a" {
  vpc_id            = aws_vpc.ecs-vpc.id
  cidr_block        = cidrsubnet(var.cidr_block, 8, 1)
  availability_zone = "${data.aws_region.current.name}a"
  tags = merge(
    local.tags, {
      Name = "${var.project_name}-priv-sub-1a"
    }
  )
}
resource "aws_subnet" "ecs_sub_priv_1b" {
  vpc_id            = aws_vpc.ecs-vpc.id
  cidr_block        = cidrsubnet(var.cidr_block, 8, 2)
  availability_zone = "${data.aws_region.current.name}b"
  tags = merge(
    local.tags, {
      Name = "${var.project_name}-priv-sub-1b"
    }
  )
}
resource "aws_subnet" "ecs_sub_pub_1a" {
  vpc_id                  = aws_vpc.ecs-vpc.id
  cidr_block              = cidrsubnet(var.cidr_block, 8, 3)
  availability_zone       = "${data.aws_region.current.name}a"
  map_public_ip_on_launch = true
  tags = merge(
    local.tags, {
      Name = "${var.project_name}-pub-sub-1a"
    }
  )
}
resource "aws_subnet" "ecs_sub_pub_1b" {
  vpc_id                  = aws_vpc.ecs-vpc.id
  cidr_block              = cidrsubnet(var.cidr_block, 8, 4)
  availability_zone       = "${data.aws_region.current.name}b"
  map_public_ip_on_launch = true
  tags = merge(
    local.tags, {
      Name = "${var.project_name}-pub-sub-1b"
    }
  )
}
resource "aws_route" "ecs_access" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_vpc.ecs-vpc.main_route_table_id
  gateway_id             = aws_internet_gateway.igw.id
}
resource "aws_route_table" "ecs_pub_route_table" {
  vpc_id = aws_vpc.ecs-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = merge(
    local.tags, {
      Name = "${var.project_name}-rtb"
    }
  )
}
resource "aws_route_table" "ecs_priv_route_table-1A" {
  vpc_id = aws_vpc.ecs-vpc.id
  tags = merge(
    local.tags, {
      Name = "${var.project_name}-rtb-1A"
    }
  )
}
resource "aws_route_table" "ecs_priv_route_table-1B" {
  vpc_id = aws_vpc.ecs-vpc.id
  tags = merge(
    local.tags, {
      Name = "${var.project_name}-rtb-1B"
    }
  )
}
resource "aws_route_table_association" "ecs_rtb_priv_1a" {
  subnet_id      = aws_subnet.ecs_sub_priv_1a.id
  route_table_id = aws_route_table.ecs_priv_route_table-1A.id
}
resource "aws_route_table_association" "ecs_rtb_priv_1b" {
  subnet_id      = aws_subnet.ecs_sub_priv_1b.id
  route_table_id = aws_route_table.ecs_priv_route_table-1B.id
}
resource "aws_route_table_association" "ecs_rtb_pub_1a" {
  subnet_id      = aws_subnet.ecs_sub_pub_1a.id
  route_table_id = aws_route_table.ecs_pub_route_table.id
}
resource "aws_route_table_association" "ecs_rtb_pub_1b" {
  subnet_id      = aws_subnet.ecs_sub_pub_1b.id
  route_table_id = aws_route_table.ecs_pub_route_table.id
}