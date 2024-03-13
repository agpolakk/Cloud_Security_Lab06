# Create a VPC
resource "aws_vpc" "cidr" {
  cidr_block = var.vpc_cidr
  tags = var.common_tags
}
