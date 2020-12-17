 
provider "aws" {
    region = "us-east-1"
}

variable "ingressrules" {
  type    = list(number)
  default = [80, 443, 22, 8080, 800]
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


resource "aws_instance" "jenkins_master" {
    ami                         = "ami-049c5cbf77bab0316" 
    count                       = 1
    instance_type               = "t2.micro"
    key_name                    = "Git"
    associate_public_ip_address = true
    vpc_security_group_ids      = [aws_security_group.web_traffic.name] 


    tags = {
        Name            = "Jenkins-Master"
        ProvisionedBy   = "Terraform"
    }
}


resource "aws_instance" "jenkins_slave" {
    ami                         = "ami-049c5cbf77bab0316" 
    count                       =  2
    instance_type               = "t2.micro"
    key_name                    = "Git"
    associate_public_ip_address = true
    vpc_security_group_ids      = [aws_security_group.web_traffic.name] 
   
    tags = {
        Name            = "Jenkins-Slave-${count.index+1}"
        ProvisionedBy   = "Terraform"
    }
}