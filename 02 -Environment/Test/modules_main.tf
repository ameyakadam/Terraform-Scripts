provider "aws" {
    region = "us-east-1"
}

resource "aws_s3_bucket" "test" {
  bucket = "kalin_bhai_123"
  acl    = "private"

  tags = {
    Name        = "My bucket"
    Environment = "test"
  }
}


resource "aws_security_group" "web_traffic" {
  name        = "Allow web traffic"
  description = "Allow ssh and standard http/https ports inbound and everything outbound"

  dynamic "ingress" {
    iterator = port
    for_each = var.ingressrules
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
      
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Terraform" = "true"
  }
}


module "test_module" {
    source = ""
    ami                         = "ami-049c5cbf77bab0316" 
    instance_type               = "t2.micro"
    key_name                    = var.key
    vpc_security_group_ids      = [aws_security_group.web_traffic.name] 
    Name            = "test"
    ProvisionedBy   = "Terraform"
}


