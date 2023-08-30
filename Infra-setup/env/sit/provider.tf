provider "aws" {
  region = "eu-north-1"
}

terraform {
  backend "s3" {
    bucket         = "<BUCKET_NAME>"
    key            = "statefile/wordpress-sit.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "<TABLE_NAME>"
  }
}
