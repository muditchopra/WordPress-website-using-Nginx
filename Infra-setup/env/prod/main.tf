module "infraSetup" {
  source = "../../wordpress"
  env    = "prod"

  aws_region  = "eu-north-1"
  key_name    = "wordpress-nginx-key"
  domain_name = "wordpress-nginx11.com"
}
