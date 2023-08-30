provider "aws" {
  region = "eu-north-1"
}

terraform {
  backend "s3" {
    bucket         = "<BUCKET_NAME_without_angular_brackets>"
    key            = "statefile/wordpress-dev.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "<TABLE_NAME_without_angular_brackets>"
  }
}
