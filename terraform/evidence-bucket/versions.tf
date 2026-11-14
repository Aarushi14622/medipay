terraform {
  required_version = ">= 1.16.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.70"
    }
  }
}

# UK data residency: everything lives in London (eu-west-2).
# Set use_localstack = true to apply against LocalStack on the VM (no AWS account, no cost).
provider "aws" {
  region = "eu-west-2"

  access_key                  = var.use_localstack ? "test" : null
  secret_key                  = var.use_localstack ? "test" : null
  skip_credentials_validation = var.use_localstack
  skip_requesting_account_id  = var.use_localstack
  s3_use_path_style           = var.use_localstack

  endpoints {
    s3  = var.use_localstack ? "http://localhost:4566" : null
    kms = var.use_localstack ? "http://localhost:4566" : null
  }

  default_tags {
    tags = {
      project             = "medipay"
      owner               = "security"
      data_classification = "internal"
      managed_by          = "terraform"
    }
  }
}
