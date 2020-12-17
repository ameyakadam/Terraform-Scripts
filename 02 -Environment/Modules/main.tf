resource "aws_instance" "examplevm"{
    ami = var.ami
    instance_type = var.instance_type
    key_name = var.key_name
    vpc_security_group_ids = var.vpc_security_group_ids
    tags = {
        name = var.name
    }
}

