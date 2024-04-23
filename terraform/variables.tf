locals {
  name = "tf-ansible-workflow-${var.spacelift_stack_id}"

  # CIDR block for the main VPC
  vpc_cidr        = "10.0.0.0/20"
  azs             = slice(data.aws_availability_zones.available.names, 0, 1)
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 4, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 4, k + 3)]


  user_data = <<-EOT
    #!/bin/bash
    echo "Hello Terraform!"
  EOT
  tags = {
    Environment      = var.environment,
    Name             = "tf-ansible-workflow"
    SpaceliftStackID = var.spacelift_stack_id
    Ansible          = "true"
  }

}

variable "environment" {
  type    = string
  default = "testing-stuff"
}

variable "spacelift_run_id" {
  type = string
}

variable "spacelift_stack_id" {
  type = string
}

variable "spacelift_ansible_stack_id" {
  type = string
}

variable "aws_region" {
  type    = string
  default = "eu-central-1"
}

variable "spacelift_labels" {
  type    = list(string)
  default = ["folder:ansible-example"]
}

variable "aws_instances_count" {
  type    = number
  default = 1
}

variable "space_id" {
  type    = string
  default = "root"
}
