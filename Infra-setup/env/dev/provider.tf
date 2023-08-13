provider "aws" {
  region = "eu-north-1"
}

terraform {
  backend "s3" {
    bucket         = "dev-wordpress-terraform-state-eu-north-1"
    key            = "statefile/wordpress-dev.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "dev-wordpress-terraform-state"
  }
}