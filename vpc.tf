data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.77.0"

  name            = var.project
  cidr            = "10.1.0.0/16"
  azs             = data.aws_availability_zones.available.names
  public_subnets  = ["10.0.30.0/24", "10.0.31.0/24", "10.0.32.0/24"]
  private_subnets = ["10.0.40.0/24", "10.0.41.0/24", "10.0.42.0/24"]

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway = true
  enable_vpn_gateway = true

  create_igw = true
  #create_database_internet_gateway_route = true

}

module "app_security_group" {
  source  = "terraform-aws-modules/security-group/aws//modules/web"
  version = "4.7.0"

  name        = "${var.project}-web"
  description = "Security group for web-servers with HTTP ports open within VPC"
  vpc_id      = module.vpc.vpc_id

  #   ingress_cidr_blocks = module.vpc.public_subnets_cidr_blocks
  ingress_cidr_blocks = ["0.0.0.0/0"]
}

module "lb_security_group" {
  source  = "terraform-aws-modules/security-group/aws//modules/web"
  version = "3.17.0"

  name        = "${var.project}-lb"
  description = "Security group for load balancer with HTTP ports open to the Interwebs"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
}
