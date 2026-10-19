resource "yandex_dns_zone" "app" {
  name   = "app-zone"
  zone   = "${var.domain}."
  public = true
}

resource "yandex_dns_recordset" "app" {
  zone_id = yandex_dns_zone.app.id
  name    = "${var.domain}."
  type    = "A"
  ttl     = 300
  data    = [yandex_vpc_address.balancer.external_ipv4_address[0].address]
}

# Сертификат Let's Encrypt, подтверждение владения доменом через DNS-запись
resource "yandex_cm_certificate" "domain" {
  name    = "app-certificate"
  domains = [var.domain]

  managed {
    challenge_type = "DNS_CNAME"
  }
}

resource "yandex_dns_recordset" "certificate_challenge" {
  zone_id = yandex_dns_zone.app.id
  name    = yandex_cm_certificate.domain.challenges[0].dns_name
  type    = yandex_cm_certificate.domain.challenges[0].dns_type
  ttl     = 600
  data    = [yandex_cm_certificate.domain.challenges[0].dns_value]
}
