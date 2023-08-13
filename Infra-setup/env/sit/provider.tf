provider "aws" {
  region = "eu-north-1"
}

terraform {
  backend "s3" {
    bucket         = "sit-wordpress-terraform-state-eu-north-1"
    key            = "statefile/wordpress-sit.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "sit-wordpress-terraform-state"
  }
}