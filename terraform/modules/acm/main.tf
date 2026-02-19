# modules/acm/main.tf

# 1️⃣ ACM certificate
resource "aws_acm_certificate" "this" {
  domain_name               = var.domain_name
  subject_alternative_names = var.subject_alternative_names
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# 2️⃣ Route53 validation records
resource "aws_route53_record" "validation" {
  count   = length(aws_acm_certificate.this.domain_validation_options)
  zone_id = var.hosted_zone_id
  name    = aws_acm_certificate.this.domain_validation_options[count.index].resource_record_name
  type    = aws_acm_certificate.this.domain_validation_options[count.index].resource_record_type
  ttl     = 60
  records = [aws_acm_certificate.this.domain_validation_options[count.index].resource_record_value]

  allow_overwrite = true

  lifecycle {
    ignore_changes = [records]
  }
}

# 3️⃣ ACM certificate validation
resource "aws_acm_certificate_validation" "this" {
  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = [for r in aws_route53_record.validation : r.fqdn]
}

