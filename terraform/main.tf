provider "aws" {
  region = "eu-central-1"
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_region" "current" {}

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name        = var.vpc_name
    Environment = "demo_env"
    Terraform   = "true"
  }
}

resource "aws_subnet" "private_subnets" {
  for_each = var.private_subnets

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, each.value.cidr_index)
  availability_zone = data.aws_availability_zones.available.names[each.value.az_index]

  tags = {
    Name        = each.key
    Environment = "demo"
    Terraform   = "true"
  }
}

resource "aws_subnet" "public_subnets" {
  for_each = var.public_subnets

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, each.value.cidr_index)
  availability_zone = data.aws_availability_zones.available.names[each.value.az_index]

  tags = {
    Name        = each.key
    Environment = "demo"
    Terraform   = "true"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.vpc_name}-igw"
    Environment = "demo"
    Terraform   = "true"
  }
}

resource "aws_eip" "nat_eip" {
  vpc     = true
  depends_on = [aws_internet_gateway.igw]
  tags = {
    Name        = "${var.vpc_name}-nat-eip"
    Environment = "demo"
    Terraform   = "true"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  depends_on    = [aws_subnet.public_subnets]
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnets["public_subnet-1"].id

  tags = {
    Name        = "${var.vpc_name}-nat-gw"
    Environment = "demo"
    Terraform   = "true"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
    # nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
  tags = {
    Name        = "${var.vpc_name}-public-rt"
    Environment = "demo"
    Terraform   = "true"
  }
}
