## Deploying a WordPress-based website on AWS using Terraform

This project aims to provide you with the code and tools necessary to deploy a scalable, fault-tolerant, and highly-available [WordPress](https://wordpress.com/) website on [AWS](https://aws.amazon.com/) infrastructure using the Infrastructure as Code (IaC) tool [Terraform](https://www.terraform.io/).

### Prerequisites
- an AWS account
- AWS CLI installed and configured with your credentials on your machine
- Terraform installed on you machine
- (optional) a text editor or IDE for making changes to the variables (or even the rest of the code)
- (optional) git for cloning this repo to your local machine

### AWS services used
- VPC
- Elastic Compute Cloud (EC2), including EC2 Auto Scaling and Load Balancing
- Relational Database Service (RDS)

### Variables
All the values necessary for a quick adjustment of the environment are defined as variables in the [variables.tf](/terraform/variables.tf) file, making it easy to eg. deploy the server in another AWS Region.

### Infrastructure
![Infrastructure Diagram showing a VPC comprised of 2 Availability Zones containing one public and one private subnet each. One public subnet contains the bastion host EC2 machine, the other contains the NAT gateway. Both private subnets each contain two members of the associated auto scaling group as well as one RDS instance running MariaDB. An application load balancer placed in both public subnets distributes traffic to the bastion host and the auto scaling group.](/pictures/infrastructure-diagram-wordpress-aws-terraform.drawio.png)

### A word on S3
This setup does not contain an S3 bucket. Such a bucket could be used to store a SQL dump from which to restore an existing database, however, this repo is meant to provide the infrastructure for a quick setup of a new WordPress website, which can then be customized to the user's liking.

### A word on HTTPS
Currently, I have no SSL certificate, so HTTPS is not fully enabled for this setup (ie. you cannot connect to the WordPress server via HTTPS, but a web browser with modern security settings will still be able to reach it). My code does contain some of the prerequisites for that, however, I was so far obviously unable to test it.