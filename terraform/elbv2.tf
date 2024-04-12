# Create application load balancer
resource "aws_lb" "wordpress-alb" {
  name               = "wordpress-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow-http.id]
  subnets            = [aws_subnet.public-1.id, aws_subnet.public-2.id]
  ip_address_type    = "ipv4"

  tags = {
    Name = "wordpress-alb"
    Unit = "wordpress"
  }
}

# Create target group
resource "aws_lb_target_group" "wordpress-tg" {
  name        = "wordpress-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.royal-vpc.id

  health_check {
    enabled             = true
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 10
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "wordpress-tg"
    Unit = "wordpress"
  }
}

# Create HTTP listener
resource "aws_lb_listener" "wordpress-http-listener" {
  load_balancer_arn = aws_lb.wordpress-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wordpress-tg.arn
  }

  tags = {
    Name = "wordpress-http-listener"
    Unit = "wordpress"
  }
}

# Create HTTPS listener; requires an SSL certificate
/* resource "aws_lb_listener" "wordpress-https-listener" {
  load_balancer_arn = aws_lb.wordpress-alb.arn
  port              = "443"
  protocol          = "HTTPS"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wordpress-tg.arn
  }

  tags = {
    Name = "wordpress-https-listener"
    Unit = "wordpress"
  }
} */

# Create target group attachment; attaching WP instance so I can reach the WP server via ALB DNS name
resource "aws_lb_target_group_attachment" "wordpress-tg-attach" {
  target_group_arn = aws_lb_target_group.wordpress-tg.arn
  target_id        = aws_instance.wp-instance[count.index].id
  count            = length(aws_instance.wp-instance)
}