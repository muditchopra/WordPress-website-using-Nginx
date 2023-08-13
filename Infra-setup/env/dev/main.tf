module "infraSetup" {
  source = "../../wordpress"
  env    = "dev"

  aws_region  = "eu-north-1"
  key_name    = "wordpress-nginx-key"
  domain_name = "wordpress-nginx.com"
}