################################################################################
# Virtual private cloud (VPC)
################################################################################

module "vpc" {
  source                       = "terraform-aws-modules/vpc/aws"
  version                      = "3.14.4"
  name                         = var.vpc_name
  cidr                         = var.vpc_cidr
  azs                          = var.vpc_azs
  private_subnets              = var.vpc_private_subnets
  public_subnets               = var.vpc_public_subnets
  database_subnets             = var.vpc_database_subnets
  create_database_subnet_group = true
  enable_dns_hostnames         = true
  enable_dns_support           = true
  enable_nat_gateway           = true
  single_nat_gateway           = true
  tags                         = var.vpc_tags
}

# Add to vpc.tf (after your existing VPC/subnet resources)
resource "aws_vpc_endpoint" "s3" {
 vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.private.id]  # Your private route table
}

 #vpc.tf
resource "aws_vpc" "main" {  # Must match references (e.g., `aws_vpc.main.id`)
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "Main-VPC"
 }
}

resource "aws_route_table" "private" {  # Must match `aws_route_table.private.id`
 vpc_id = aws_vpc.main.id
  tags = {
    Name = "Private-Route-table"
  }
}