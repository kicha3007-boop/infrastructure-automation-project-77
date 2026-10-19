output "web_public_ips" {
  description = "Публичные адреса веб-серверов — для инвентори Ansible"
  value       = yandex_compute_instance.web[*].network_interface[0].nat_ip_address
}

output "balancer_ip" {
  description = "Внешний адрес балансировщика"
  value       = yandex_vpc_address.balancer.external_ipv4_address[0].address
}

output "db_host" {
  description = "Адрес кластера PostgreSQL"
  value       = yandex_mdb_postgresql_cluster.app.host[0].fqdn
}

output "dns_name_servers" {
  description = "NS-серверы Yandex Cloud для делегирования домена у регистратора"
  value       = ["ns1.yandexcloud.net", "ns2.yandexcloud.net"]
}
