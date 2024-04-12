# Create DB subnet group
resource "aws_db_subnet_group" "wp-db-subnet-group" {
  name       = "wp-db-subnet-group"
  subnet_ids = [aws_subnet.private-1.id, aws_subnet.private-2.id]
}

# Create RDS MariaDB Database Instance
resource "aws_db_instance" "royal-wp-db" {
  identifier             = "royal-wp-db"
  allocated_storage      = var.rds-instance-storage
  engine                 = var.database-engine
  instance_class         = var.rds-instance-class
  db_subnet_group_name   = aws_db_subnet_group.wp-db-subnet-group.name
  vpc_security_group_ids = [aws_security_group.allow-mysql.id]
  username               = var.db-username
  password               = var.db-password
  publicly_accessible    = false
  deletion_protection    = false
  skip_final_snapshot    = true
  storage_encrypted      = true
  multi_az               = true
  tags = {
    Name = "royal-wp-db"
    Unit = "wordpress"
  }
}