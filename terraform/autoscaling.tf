#Create launch template
resource "aws_launch_template" "wp-launch-template" {
  name                   = "wp-launch-template"
  image_id               = data.aws_ami.latest-linux-ami.id
  instance_type          = var.ec2-instance-type
  key_name               = var.key-name
  vpc_security_group_ids = [aws_security_group.allow-http.id, aws_security_group.allow-ssh.id]
  user_data              = base64encode(data.template_file.ec2-user-data-asg.rendered)

  tags = {
    Name = "wp-launch-template"
    Unit = "wordpress"
  }
}

#Create autoscaling group with ELB health check
resource "aws_autoscaling_group" "wp-asg" {
  name                      = "wp-asg"
  vpc_zone_identifier       = [aws_subnet.private-1.id, aws_subnet.private-2.id]
  target_group_arns         = [aws_lb_target_group.wordpress-tg.id]
  max_size                  = var.max-instances
  min_size                  = var.min-instances
  desired_capacity          = var.desired-instances
  health_check_type         = "ELB"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.wp-launch-template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "wp-asg"
    propagate_at_launch = true
  }
}

#Create target tracking scaling policy
resource "aws_autoscaling_policy" "wp-policy" {
  name                   = "wp-policy"
  autoscaling_group_name = aws_autoscaling_group.wp-asg.name
  policy_type            = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = var.scale-out-threshold
  }
}