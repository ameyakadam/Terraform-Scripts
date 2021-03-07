provider "aws" {
    region = "us-east-2"
    access_key = var.access_key
    secret_key = var.secret_key
}

resource "aws_security_group" "Puppet" {
  name        = "Configuration for puppet lab"

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


resource "aws_instance" "myec2" {
    ami = var.aws_ami
    instance_type = "t2.micro"
    count = 2
    key_name                    = "Ameya"
    associate_public_ip_address = true
    vpc_security_group_ids      = [aws_security_group.Puppet.name] 
   
    tags = {
        Name            = "Ameya-Puppet-Agent-${count.index+1}"
    }
}
