variable "vpc_cidr" {
  type = string
  default = "10.0.0.0/16"
}
locals {
  common_tags = {
    Assignment = "CCGC 5501 Cloud Security Lab 6"
    Name = "Albin.Polakkattil"
    Student_id = "Humber ID: n01009389"
    Environment = "Learning"
  }
}
