# База данных как сервис: Managed PostgreSQL
resource "yandex_mdb_postgresql_cluster" "app" {
  name        = "app-db"
  environment = "PRODUCTION"
  network_id  = yandex_vpc_network.app.id

  config {
    version = 16

    resources {
      resource_preset_id = "s2.micro"
      disk_type_id       = "network-ssd"
      disk_size          = 10
    }
  }

  host {
    zone      = var.yc_zone
    subnet_id = yandex_vpc_subnet.app.id
  }
}

resource "yandex_mdb_postgresql_user" "app" {
  cluster_id = yandex_mdb_postgresql_cluster.app.id
  name       = var.db_user
  password   = var.db_password
}

resource "yandex_mdb_postgresql_database" "app" {
  cluster_id = yandex_mdb_postgresql_cluster.app.id
  name       = var.db_name
  owner      = yandex_mdb_postgresql_user.app.name
}
