# rise-of-machines/dnszones.tf
#      _                                    
#   __| |_ __  ___ _______  _ __   ___  ___ 
#  / _` | '_ \/ __|_  / _ \| '_ \ / _ \/ __|
# | (_| | | | \__ \/ / (_) | | | |  __/\__ \
#  \__,_|_| |_|___/___\___/|_| |_|\___||___/
# -------------------------------------------------------------------------------------------------
locals { }

#  ____             _       ____ _____ 
# |  _ \ ___  _   _| |_ ___| ___|___ / 
# | |_) / _ \| | | | __/ _ \___ \ |_ \ 
# |  _ < (_) | |_| | ||  __/___) |__) |
# |_| \_\___/ \__,_|\__\___|____/____/ 
# -------------------------------------------------------------------------------------------------
resource aws_route53_zone "external-zone" {
  name    = local.domain
  comment = ""
  tags    = local.defaulttag
}

resource aws_route53_record "external-zone-txt-spf" {
  name    = local.domain
  type    = "TXT"
  ttl     = "300"
  records = ["v=spf1 include:amazonses.com ~all"]
  zone_id = aws_route53_zone.external-zone.zone_id
}

resource aws_route53_record "external-zone-cname" {
  name    = "www1.${local.domain}"
  type    = "CNAME"
  ttl     = "300"
  records = ["host1.neko.example.jp."]
  zone_id = aws_route53_zone.external-zone.zone_id
}

resource aws_route53_record "external-zone-a" {
  name    = "www.${local.domain}"
  type    = "A"
  zone_id = aws_route53_zone.external-zone.zone_id

  alias {
    name = aws_lb.nlb-1.dns_name
    zone_id = aws_lb.nlb-1.zone_id
    evaluate_target_health = true
  }
}

resource aws_route53_record "external-zone-validate-cert-1" {
  for_each = {
    for e in aws_acm_certificate.cert1.domain_validation_options: e.domain_name => {
      name   = e.resource_record_name
      record = e.resource_record_value
      type   = e.resource_record_type
    }
  }

  name            = each.value.name
  records         = [each.value.record]
  type            = each.value.type
  ttl             = 300
  allow_overwrite = true
  zone_id         = aws_route53_zone.external-zone.zone_id
}

