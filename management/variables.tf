variable "aws_role" {
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

variable "github_org_name" {
  type    = string
  default = ""
}

variable "space_id" {
  type = string
  default = "root"
}