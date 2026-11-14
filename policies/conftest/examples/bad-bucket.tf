# Broken on purpose: US region and an unclassified bucket. CI expects conftest to FAIL this.
provider "aws" {
  region = "us-east-1"
}
resource "aws_s3_bucket" "b" {
  bucket = "x"
}
