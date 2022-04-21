data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_eip" "nat" {
  count = 1

  vpc = true
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.77.0"

  name            = var.project
  cidr            = "10.2.0.0/16"
  azs             = data.aws_availability_zones.available.names
  public_subnets  = ["10.2.30.0/24", "10.2.31.0/24", "10.2.32.0/24"]
  private_subnets = ["10.2.40.0/24", "10.2.41.0/24", "10.2.42.0/24"]

  enable_dns_hostnames = false
  enable_dns_support   = false

  enable_vpn_gateway = true

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  create_igw = true
  #create_database_internet_gateway_route = true
  reuse_nat_ips       = true                    # <= Skip creation of EIPs for the NAT Gateways
  external_nat_ip_ids = "${aws_eip.nat.*.id}"   # <= IPs specified here as input to the module
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
