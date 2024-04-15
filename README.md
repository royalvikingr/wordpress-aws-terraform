## Deploying a WordPress server on AWS using Terraform

In this project, I deploy a scalable, fault-tolerant, and highly-available [WordPress](https://wordpress.com/) server on [AWS](https://aws.amazon.com/) using the Infrastructure as Code (IaC) tool [Terraform](https://www.terraform.io/).

### AWS services used
- VPC
- Elastic Compute Cloud (EC2), including EC2 Auto Scaling and Load Balancing
- Relational Database Service (RDS)

### Variables
All the values necessary for a quick adjustment of the environment are defined as variables in the [variables.tf](/terraform/variables.tf) file, making it easy to eg. deploy the server in another AWS Region.

### Infrastructure
![Infrastructure Diagram with a VPC comprised of 2 Availability Zones containing 1 public and 1 private subnet each. One public subnet contains the command host EC2 machine, both public subnets contain 2 members of the associated Auto Scaling group. Both private subnets contain one RDS instance running MariaDB.](/pictures/aws-wordpress-terraform.drawio.png)

### A word on S3
This setup does not contain an S3 bucket. Such a bucket could be used to store a SQL dump from which to restore an existing database, however, this repo is meant to provide the infrastructure for a quick setup of a new WordPress website, which can then be customized to the user's liking.

### A word on HTTPS
Currently, I have no SSL certificate, so HTTPS is not fully enabled for this setup (ie. you cannot connect to the WordPress server via HTTPS, but a web browser with modern security settings will still be able to reach it). My code does contain some of the prerequisites for that, however, I was so far obviously unable to test it.