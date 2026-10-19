resource "yandex_alb_target_group" "web" {
  name = "web-target-group"

  dynamic "target" {
    for_each = yandex_compute_instance.web
    content {
      subnet_id  = yandex_vpc_subnet.app.id
      ip_address = target.value.network_interface[0].ip_address
    }
  }
}

resource "yandex_alb_backend_group" "web" {
  name = "web-backend-group"

  http_backend {
    name             = "web-backend"
    port             = var.app_port
    target_group_ids = [yandex_alb_target_group.web.id]

    healthcheck {
      timeout  = "2s"
      interval = "5s"

      http_healthcheck {
        path = "/"
      }
    }
  }
}

resource "yandex_alb_http_router" "web" {
  name = "web-router"
}

resource "yandex_alb_virtual_host" "web" {
  name           = "web-host"
  http_router_id = yandex_alb_http_router.web.id
  authority      = [var.domain]

  route {
    name = "app"

    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.web.id
      }
    }
  }
}

resource "yandex_vpc_address" "balancer" {
  name = "balancer-address"

  external_ipv4_address {
    zone_id = var.yc_zone
  }
}

# Балансировщик принимает HTTPS, а с HTTP перенаправляет на HTTPS
resource "yandex_alb_load_balancer" "web" {
  name       = "web-balancer"
  network_id = yandex_vpc_network.app.id

  allocation_policy {
    location {
      zone_id   = var.yc_zone
      subnet_id = yandex_vpc_subnet.app.id
    }
  }

  listener {
    name = "https"

    endpoint {
      address {
        external_ipv4_address {
          address = yandex_vpc_address.balancer.external_ipv4_address[0].address
        }
      }
      ports = [443]
    }

    tls {
      default_handler {
        certificate_ids = [yandex_cm_certificate.domain.id]

        http_handler {
          http_router_id = yandex_alb_http_router.web.id
        }
      }
    }
  }

  listener {
    name = "http-redirect"

    endpoint {
      address {
        external_ipv4_address {
          address = yandex_vpc_address.balancer.external_ipv4_address[0].address
        }
      }
      ports = [80]
    }

    http {
      redirects {
        http_to_https = true
      }
    }
  }
}
