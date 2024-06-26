# Configure the AWS Provider
terraform {
  required_providers {
    spacelift = {
      source = "spacelift-io/spacelift"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

provider "spacelift" {
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.20240610.1-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"]
}

data "aws_availability_zones" "available" {}

module "ec2" {
  count = var.aws_instances_count

  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.6.1"

  name = local.name

  ami               = var.ami != "" ? var.ami : data.aws_ami.ubuntu.id
  instance_type     = "t2.micro"
  availability_zone = element(module.vpc.azs, 0)

  // TODO change to private subnet and set up proper netowrking
  subnet_id                   = element(module.vpc.public_subnets, 0)
  vpc_security_group_ids      = [module.security_group.security_group_id]
  associate_public_ip_address = true
  disable_api_stop            = false


  iam_role_description = "IAM role for EC2 instance"
  iam_role_policies = {
    AdministratorAccess = "arn:aws:iam::aws:policy/AdministratorAccess"
  }

  iam_instance_profile = "AmazonSSMRoleForInstancesQuickSetup"

  user_data_base64            = base64encode(local.user_data)
  user_data_replace_on_change = true

  root_block_device = [
    {
      volume_size = 16,
    },
  ]

  key_name = aws_key_pair.ansible-key.key_name


  tags = local.tags
}

