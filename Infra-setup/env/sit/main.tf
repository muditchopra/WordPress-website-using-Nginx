module "infraSetup" {
  source = "../../wordpress"
  env    = "sit"

  aws_region  = "eu-north-1"
  key_name    = "webserver-key"
  domain_name = "wordpress-nginx11.com"
}
