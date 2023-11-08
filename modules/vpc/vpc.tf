# VPC

locals {
  subnet_1_map = {
    dev   = "us-east-1a"
    homol = "us-east-1a"
    prod  = ""
  }
}

locals {
  subnet_2_map = {
    dev   = "us-east-1b"
    homol = "us-east-1b"
    prod  = ""
  }
}

resource "aws_vpc" "poc-infra-vpc" {
  cidr_block           = var.env == "dev" ? "10.0.0.0/24" : "10.0.1.0/24"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.app_name}-vpc"
  }
}

# Subnets

## Privadas

resource "aws_subnet" "poc-infra-subnet-privada-a" {
  vpc_id            = aws_vpc.poc-infra-vpc.id
  cidr_block        = var.env == "dev" ? "10.0.0.0/26" : "10.0.1.0/26"
  availability_zone = local.subnet_1_map[var.env] // TO_D0: Deixar configuravel

  tags = {
    Name = "${var.app_name}-subnet-privada-a"
  }
}


resource "aws_subnet" "poc-infra-subnet-privada-b" {
  vpc_id            = aws_vpc.poc-infra-vpc.id
  cidr_block        = var.env == "dev" ? "10.0.0.64/26" : "10.0.1.64/26"
  availability_zone = local.subnet_2_map[var.env]

  tags = {
    Name = "${var.app_name}-subnet-privada-b"
  }
}

## Publicas

resource "aws_subnet" "poc-infra-subnet-publica-a" {
  vpc_id                  = aws_vpc.poc-infra-vpc.id
  cidr_block              = var.env == "dev" ? "10.0.0.128/26" : "10.0.1.128/26"
  availability_zone       = local.subnet_1_map[var.env]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.app_name}-subnet-publica-a"
  }
}


resource "aws_subnet" "poc-infra-subnet-publica-b" {
  vpc_id                  = aws_vpc.poc-infra-vpc.id
  cidr_block              = var.env == "dev" ? "10.0.0.192/26" : "10.0.1.192/26"
  availability_zone       = local.subnet_2_map[var.env]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.app_name}-subnet-publica-b"
  }
}


## Internet Gateway e Route Table Publica

resource "aws_internet_gateway" "poc-infra-igw" {
  vpc_id = aws_vpc.poc-infra-vpc.id

  tags = {
    Name = "${var.app_name}-main"
  }
}

resource "aws_route_table" "publica-rt" {
  vpc_id = aws_vpc.poc-infra-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.poc-infra-igw.id
  }

  tags = {
    Name = "${var.app_name}-publica-rt"
  }
}

resource "aws_route_table_association" "publica-rt-association-a" {
  subnet_id      = aws_subnet.poc-infra-subnet-publica-a.id
  route_table_id = aws_route_table.publica-rt.id
}

resource "aws_route_table_association" "publica-rt-association-b" {
  subnet_id      = aws_subnet.poc-infra-subnet-publica-b.id
  route_table_id = aws_route_table.publica-rt.id
}


## Nat Gateway e Route Table Privada

resource "aws_eip" "eip-ngw" {
}

resource "aws_nat_gateway" "poc-infra-nat-gw" {
  allocation_id = aws_eip.eip-ngw.id
  subnet_id     = aws_subnet.poc-infra-subnet-publica-a.id

  tags = {
    Name = "${var.app_name}-nat-gateway"
  }

  depends_on = [aws_internet_gateway.poc-infra-igw]
}

resource "aws_route_table" "privada-rt" {
  vpc_id = aws_vpc.poc-infra-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.poc-infra-nat-gw.id
  }

  tags = {
    Name = "${var.app_name}-privada-rt"
  }
}

resource "aws_route_table_association" "privada-rt-association-a" {
  subnet_id      = aws_subnet.poc-infra-subnet-privada-a.id
  route_table_id = aws_route_table.privada-rt.id
}

resource "aws_route_table_association" "privada-rt-association-b" {
  subnet_id      = aws_subnet.poc-infra-subnet-privada-b.id
  route_table_id = aws_route_table.privada-rt.id
}
