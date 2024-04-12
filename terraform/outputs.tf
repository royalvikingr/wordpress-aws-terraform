# Output the Load Balancer DNS name
output "alb-dns-name" {
  value = aws_lb.wordpress-alb.dns_name
}

# Output the DB endpoint
output "db-endpoint" {
  value = aws_db_instance.royal-wp-db.endpoint
}

# Output the Elastic IP address
output "elastic-ip" {
  value = aws_eip.royal-nat-eip.public_ip
}