# rise-of-machines/main.tf
# -------------------------------------------------------------------------------------------------
variable "region" {
  type    = string
  default = "ap-northeast-1"
}
variable "abzone" {
  type    = map(string)
  default = {
    a = "us-east-1a"
    b = "us-east-1b"
    c = "us-east-1c"
    d = "us-east-1d"
    e = "us-east-1e"
    f = "us-east-1f"
  }
}

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
  region = "us-east-1"

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
  alias  = "nvirginia"
  region = "us-east-1"
}

provider "aws" {
  alias  = "tokyo"
  region = "ap-northeast-1"
}

terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.74"
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

