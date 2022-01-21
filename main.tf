# rise-of-machines/main.tf
# -------------------------------------------------------------------------------------------------
locals {
  # Used at each resource name, each "Name" value of tags. 
  # Do not forget check and edit the follwoing TF files:
  #   - dnszones.tf
  #   - firewall.tf
  #   - sendmail.tf
  #   - tlscerts.tf
  prefix = "neko-nyaan"
  domain = "neko.example.jp"

  # The following tags are assigned to each aws resource
  defaulttag = {
    Project = ""
    Domain  = local.domain
    BuiltBy = "Terraform"
  }

  # Allow SSH access from the following CIDR blocks
  cidrblocks = {
    developers = [
      "192.0.2.0/24",
      "198.51.100.0/24",
      "203.0.113.0/24"
    ]
  }
}

# -------------------------------------------------------------------------------------------------
provider "aws" {
  region = "us-east-1"
}

terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.25.0"
    }
  }

# backend "s3" {
#   backet  = "terraform-state-files"
#   region  = "us-east-1"
#   profile = "default"
#   key     = "terraform.tfstate"
#   encrypt = true
# }
}

