provider "aws" {
  region = "eu-north-1"
}

terraform {
  backend "s3" {
    bucket         = "prod-wordpress-terraform-state-eu-north-1"
    key            = "statefile/wordpress-prod.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "prod-wordpress-terraform-state"
  }
}