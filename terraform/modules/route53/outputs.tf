# modules/route53/outputs.tf
output "hosted_zone_id" {
  value = data.aws_route53_zone.lib_zone.zone_id
}

