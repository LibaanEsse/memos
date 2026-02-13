resource "aws_route53_zone" "lib_zone" {
  name = "libaane.org"
}


output "lib_zone_id" {
  value = aws_route53_zone.lib_zone.zone_id
}
