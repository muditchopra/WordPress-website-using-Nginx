module "infraSetup" {
  source = "../../wordpress"
  env    = "prod"

  aws_region  = "eu-north-1"
  key_name    = "webserver-key"
  domain_name = "wordpress-nginx11.com"
}
