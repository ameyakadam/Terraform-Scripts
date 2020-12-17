provider "aws" {
    region = "us-east-1"
}

terraform {
  backend "s3" {}
}

data "terraform_remote_state" "remote-state" {
  backend = "s3"
  config {
    bucket = "ameya-mastermnd-07"
    region     = "us-east-1"
    key        = "dev"
  }
}


module "test_module" {
    source = ""
    ami                         = "ami-049c5cbf77bab0316" 
    instance_type               = "t2.large"
    key_name                    = var.key
    vpc_security_group_ids      = var.security_group_ids
}