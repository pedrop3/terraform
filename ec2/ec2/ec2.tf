terraform {
  backend "s3" {
    bucket = "ec2-test"
    encrypt = "true"
    key = "terraform/stack/ec2/terraform.tfstate"
    region = "us-east-1"
  }
}


provider "aws" {
  region =  "us-east-1"
}

data "aws_region" "current" {}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "ec2-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

module "ec2_cluster_sg" {

  source = "./modules/sg"
  name          = "ec2_cluster_sg"
  description   = "EC2 Security Group"
  vpc_id        = "ec2-vpc"
  environment   = "develop"
  ingress_rules = [
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = [
        "173.245.48.0/20", "103.21.244.0/22", "103.31.4.0/22",
        "104.24.0.0/14", "141.101.64.0/18", "108.162.192.0/18",
        "190.93.240.0/20", "188.114.96.0/20", "197.234.240.0/22",
        "198.41.128.0/17", "162.158.0.0/15", "104.16.0.0/13",
        "172.64.0.0/13", "131.0.72.0/22"
      ]
      ipv6_cidr_blocks = [
        "2400:cb00::/32", "2606:4700::/32", "2803:f800::/32",
        "2405:b500::/32", "2405:8100::/32", "2a06:98c0::/29",
        "2c0f:f248::/32"
      ]
     security_groups = []
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      ipv6_cidr_blocks =[]
      security_groups = []
    }
  ]
}

locals {
  instance_types = {
    dev   = "t2.micro"
    stage = "t2.small"
    prod  = "m4.large"
  }
}


module "ec2_instance" {
  source = "./modules/ec2"

  environment   = "develop"
  description = "Blog to princial"
  name = "Blog"
  type = local.instance_types[terraform.workspace]
  security_groups_ec2 = module.ec2_cluster_sg.security_group_id
  
}