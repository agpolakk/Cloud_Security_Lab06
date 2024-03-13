# Create a VPC
resource "aws_vpc" "cidr" {
  cidr_block = var.vpc_cidr
  tags = local.common_tags
}
