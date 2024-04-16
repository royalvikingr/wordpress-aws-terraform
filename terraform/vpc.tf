# Create VPC to launch instances into
resource "aws_vpc" "royal-vpc" {
  cidr_block           = var.vpc-cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "royal-vpc"
    Unit = "wordpress"
  }
}

# Create subnets
resource "aws_subnet" "public-1" {
  vpc_id                  = aws_vpc.royal-vpc.id
  cidr_block              = var.pubnet1-cidr
  availability_zone       = var.az1
  map_public_ip_on_launch = true
  tags = {
    Name = "royal-pubnet1"
    Unit = "wordpress"
  }
}

resource "aws_subnet" "public-2" {
  vpc_id                  = aws_vpc.royal-vpc.id
  cidr_block              = var.pubnet2-cidr
  availability_zone       = var.az2
  map_public_ip_on_launch = true
  tags = {
    Name = "royal-pubnet2"
    Unit = "wordpress"
  }
}

resource "aws_subnet" "private-1" {
  vpc_id            = aws_vpc.royal-vpc.id
  cidr_block        = var.privnet1-cidr
  availability_zone = var.az1
  tags = {
    Name = "royal-privnet1"
    Unit = "wordpress"
  }
}

resource "aws_subnet" "private-2" {
  vpc_id            = aws_vpc.royal-vpc.id
  cidr_block        = var.privnet2-cidr
  availability_zone = var.az2
  tags = {
    Name = "royal-privnet2"
    Unit = "wordpress"
  }
}