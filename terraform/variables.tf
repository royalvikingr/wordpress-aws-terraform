### account environment key

variable "key-name" {
  default   = "vockey" # using the key of the AWS Restart Program lab environment; use your own key!
  sensitive = true
}

### AWS infrastructure variables

variable "aws-region" {
  default = "us-west-2"
}

variable "az1" {
  default = "us-west-2a"
}

variable "az2" {
  default = "us-west-2b"
}

variable "ec2-instance-type" {
  default = "t2.micro"
}

variable "rds-instance-class" {
  default = "db.t3.micro"
}

variable "rds-instance-storage" {
  default = "20"
}

variable "db-engine" {
  default = "mariadb"
}

### IP variables

variable "pub-cidr" {
  default = "0.0.0.0/0"
}

variable "vpc-cidr" {
  default = "10.0.0.0/24"
}

variable "pubnet1-cidr" {
  default = "10.0.0.0/26"
}

variable "pubnet2-cidr" {
  default = "10.0.0.64/26"
}

variable "privnet1-cidr" {
  default = "10.0.0.128/26"
}

variable "privnet2-cidr" {
  default = "10.0.0.192/26"
}

### DB variables

variable "db-name" {
  default = "wordpressdb"
}

variable "db-username" {
  default = "royalvikingr"
}

variable "db-password" {
  default   = "r0y4LV1k!nGr"
  sensitive = true
}

### Auto Scaling variables

variable "max-instances" {
  description = "the maximum number of instances the auto scaling group is allowed to have"
  default     = "4"
}

variable "min-instances" {
  description = "the minimum number of instances the auto scaling group must have"
  default     = "1"
}

variable "desired-instances" {
  description = "the desired number of instances the auto scaling should balance out on"
  default     = "1"
}

variable "scale-out-threshold" {
  description = "the CPU utilization threshold for scaling out"
  default     = "60.0"
}