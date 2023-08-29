# resource "aws_route53_zone" "primary" {
#   name = var.domain_name
# }

# resource "aws_route53_record" "www" {
#   zone_id    = aws_route53_zone.primary.zone_id
#   name       = var.domain_name
#   type       = "A"
#   ttl        = 300
#   records    = [aws_instance.web_server.public_ip]
#   depends_on = [aws_route53_zone.primary]
# }
