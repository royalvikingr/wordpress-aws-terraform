terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.aws-region
}

# Fetch the newest AMI
data "aws_ami" "latest-linux-ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*x86_64"]
  }
}

# Fetch RDS endpoint
data "aws_db_instance" "rds-endpoint" {
  db_instance_identifier = aws_db_instance.royal-wp-db.id
}

# Define userdata template file for host ec2 machine
data "template_file" "ec2-user-data-host" {
  template = file("wp-userdata-rds-host.tpl")

  vars = {
    db_name     = "${var.db-name}"
    db_username = "${var.db-username}"
    db_password = "${var.db-password}"
    db_endpoint = replace("${data.aws_db_instance.rds-endpoint.endpoint}", ":3306", "")
  }
}

# Define userdata template file for asg machines
data "template_file" "ec2-user-data-asg" {
  template = file("wp-userdata-rds-asg.tpl")

  vars = {
    db_name     = "${var.db-name}"
    db_username = "${var.db-username}"
    db_password = "${var.db-password}"
    db_endpoint = replace("${data.aws_db_instance.rds-endpoint.endpoint}", ":3306", "")
  }
}