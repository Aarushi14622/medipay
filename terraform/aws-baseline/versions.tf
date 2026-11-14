terraform {
  required_version = ">= 1.16.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.70"
    }
  }
}

# Scanned in CI, never applied in this project (decision log: no AWS account).
# If you do apply it on a real account: billing alert and root MFA FIRST (README).
provider "aws" {
  region = "eu-west-2"

  default_tags {
    tags = {
      project             = "medipay"
      owner               = "security"
      data_classification = "internal"
      managed_by          = "terraform"
    }
  }
}
