# Стейт хранится в Yandex Object Storage. Ключи доступа к бакету передаются при инициализации:
# terraform init -backend-config="access_key=..." -backend-config="secret_key=..." (см. make init)
terraform {
  backend "s3" {
    bucket = "hexlet-iac-project-77-state"
    key    = "infrastructure/terraform.tfstate"
    region = "ru-central1"

    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}
