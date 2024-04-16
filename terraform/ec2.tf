# Create Command Host EC2 instance
resource "aws_instance" "bastion-host" {
  ami                         = data.aws_ami.latest-linux-ami.id
  instance_type               = var.ec2-instance-type
  availability_zone           = var.az1
  associate_public_ip_address = true
  key_name                    = var.key-name
  vpc_security_group_ids      = [aws_security_group.allow-http.id, aws_security_group.allow-ssh.id]
  subnet_id                   = aws_subnet.public-1.id

  tags = {
    Name = "royal-bastion-host"
    Unit = "wordpress"
  }

  user_data = base64encode(data.template_file.ec2-user-data-host.rendered)
}

# Create a Security Group to allow HTTP
resource "aws_security_group" "allow-http" {
  name        = "allow-http"
  description = "Allow HTTP traffic"
  vpc_id      = aws_vpc.royal-vpc.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.pub-cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.pub-cidr]
  }

  tags = {
    Name = "allow-http"
    Unit = "wordpress"
  }
}

# Create a Security Group to allow HTTPS; deactivated b/c no cert
resource "aws_security_group" "allow-https" {
  name        = "allow-https"
  description = "Allow HTTPS traffic"
  vpc_id      = aws_vpc.royal-vpc.id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.pub-cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.pub-cidr]
  }

  tags = {
    Name = "allow-https"
    Unit = "wordpress"
  }
}

# Create a Security Group to allow SSH
resource "aws_security_group" "allow-ssh" {
  name        = "allow-ssh"
  description = "Allow SSH traffic"
  vpc_id      = aws_vpc.royal-vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.pub-cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.pub-cidr]
  }

  tags = {
    Name = "allow-ssh"
    Unit = "wordpress"
  }
}

# Create a Security Group to allow MySQL
resource "aws_security_group" "allow-mysql" {
  name        = "allow-mysql"
  description = "Allow MySQL"
  vpc_id      = aws_vpc.royal-vpc.id

  ingress {
    description     = "MySQL"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    cidr_blocks     = [var.pub-cidr]
    security_groups = [aws_security_group.allow-ssh.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.pub-cidr]
  }

  tags = {
    Name = "allow-mysql"
    Unit = "wordpress"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "igw" {
  # attach the igw to the vpc created above
  vpc_id = aws_vpc.royal-vpc.id

  tags = {
    Name = "royal-igw"
    Unit = "wordpress"
  }
}

# Allocate Elastic IP for NAT Gateway
resource "aws_eip" "royal-nat-eip" {

  tags = {
    Name = "royal-nat-eip"
    Unit = "wordpress"
  }
}

# Create a NAT Gateway for the private subnets to access the internet
resource "aws_nat_gateway" "royal-nat-gw" {
  allocation_id = aws_eip.royal-nat-eip.id
  subnet_id     = aws_subnet.public-1.id
  tags = {
    Name = "royal-nat-gw"
    Unit = "wordpress"
  }
}

# Create a route table for public subnets
resource "aws_route_table" "royal-pub-rtb" {
  vpc_id = aws_vpc.royal-vpc.id
  route {
    cidr_block = var.pub-cidr
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "royal-pub-rtb"
    Unit = "wordpress"
  }
}

# Create a route table for private subnets
resource "aws_route_table" "royal-priv-rtb" {
  vpc_id = aws_vpc.royal-vpc.id
  route {
    cidr_block = var.pub-cidr
    gateway_id = aws_nat_gateway.royal-nat-gw.id
  }
  tags = {
    Name = "royal-priv-rtb"
    Unit = "wordpress"
  }
}

# Associate the public route table with public subnet 1
resource "aws_route_table_association" "pubnet1-asso" {
  route_table_id = aws_route_table.royal-pub-rtb.id
  subnet_id      = aws_subnet.public-1.id
  depends_on     = [aws_route_table.royal-pub-rtb, aws_subnet.public-1]
}

# Associate the public route table with public subnet 2
resource "aws_route_table_association" "pubnet2-asso" {
  route_table_id = aws_route_table.royal-pub-rtb.id
  subnet_id      = aws_subnet.public-2.id
  depends_on     = [aws_route_table.royal-pub-rtb, aws_subnet.public-2]
}

# Associate the private route table with private subnet 1
resource "aws_route_table_association" "privnet1-asso" {
  route_table_id = aws_route_table.royal-priv-rtb.id
  subnet_id      = aws_subnet.private-1.id
  depends_on     = [aws_route_table.royal-priv-rtb, aws_subnet.private-1]
}

# Associate the private route table with private subnet 2
resource "aws_route_table_association" "privnet2-asso" {
  route_table_id = aws_route_table.royal-priv-rtb.id
  subnet_id      = aws_subnet.private-2.id
  depends_on     = [aws_route_table.royal-priv-rtb, aws_subnet.private-2]
}