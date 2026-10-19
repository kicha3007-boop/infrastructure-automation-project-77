resource "yandex_vpc_network" "app" {
  name = "app-network"
}

resource "yandex_vpc_subnet" "app" {
  name           = "app-subnet"
  zone           = var.yc_zone
  network_id     = yandex_vpc_network.app.id
  v4_cidr_blocks = ["10.10.0.0/24"]
}
