data "aws_route53_zone" "lib_zone" {
  name         = "libaane.org."
  private_zone = false
}

