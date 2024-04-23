module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.6.0"

  name = "vpc-for-${local.name}"

  cidr = local.vpc_cidr

  azs = local.azs

  private_subnets = local.private_subnets
  public_subnets  = local.public_subnets


  enable_dns_hostnames    = true
  enable_dns_support      = true
  map_public_ip_on_launch = true
  enable_nat_gateway      = true

  private_subnet_tags = local.tags
  public_subnet_tags  = local.tags

  tags = local.tags
}
