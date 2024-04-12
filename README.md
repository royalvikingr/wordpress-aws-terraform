## Deploying a WordPress server on AWS using Terraform

In this project, I deploy a scalable, fault-tolerant, and highly-available [WordPress](https://wordpress.com/) server on [AWS](https://aws.amazon.com/) using the Infrastructure as Code (IaC) tool [Terraform](https://www.terraform.io/).

### AWS services used
- VPC
- Elastic Compute Cloud (EC2), including EC2 Auto Scaling and Load Balancing
- Relational Database Service (RDS)

### Variables
All the values necessary for a quick adjustment of the environment are defined as variables in the [variables.tf](/terraform/variables.tf) file, making it easy to eg. deploy the server in another AWS Region.

### A word on S3
This setup does not contain an S3 bucket. Such a bucket could be used to store a SQL dump from which to restore an existing database, however, this repo is meant to provide the infrastructure for a quick setup of a new WordPress website, which can then be customized to the user's liking.

### A word on HTTPS
Currently, I have no SSL certificate, so HTTPS is not fully enabled for this setup. My code does contain at least some of the prerequisites for that, however, I was so far obviously unable to test it.