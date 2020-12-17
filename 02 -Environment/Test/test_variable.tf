variable "ingressrules" {
  type    = list(number)
  default = [80, 443, 22, 8080, 800]
}

variable "key" {
    default = "Git"
}

variable "vpc_security_group_ids" {
    default = "web_traffic"
}