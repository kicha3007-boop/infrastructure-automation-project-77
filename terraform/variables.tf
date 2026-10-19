# Секретные значения приходят из secrets.auto.tfvars, который рендерит Ansible из зашифрованного vault

variable "yc_token" {
  description = "OAuth- или IAM-токен Yandex Cloud"
  type        = string
  sensitive   = true
}

variable "yc_cloud_id" {
  description = "Идентификатор облака"
  type        = string
}

variable "yc_folder_id" {
  description = "Идентификатор каталога"
  type        = string
}

variable "yc_zone" {
  description = "Зона доступности"
  type        = string
  default     = "ru-central1-a"
}

variable "ssh_public_key" {
  description = "Публичный SSH-ключ для доступа Ansible к веб-серверам"
  type        = string
}

variable "domain" {
  description = "Домен приложения, делегированный на DNS Yandex Cloud"
  type        = string
}

variable "app_port" {
  description = "Порт приложения на веб-серверах"
  type        = number
  default     = 3000
}

variable "db_name" {
  description = "Имя базы данных приложения"
  type        = string
  default     = "app"
}

variable "db_user" {
  description = "Пользователь базы данных"
  type        = string
  default     = "app"
}

variable "db_password" {
  description = "Пароль пользователя базы данных"
  type        = string
  sensitive   = true
}

variable "datadog_api_key" {
  description = "API-ключ Datadog"
  type        = string
  sensitive   = true
}

variable "datadog_app_key" {
  description = "Application-ключ Datadog"
  type        = string
  sensitive   = true
}

variable "datadog_api_url" {
  description = "Адрес API Datadog для региона аккаунта"
  type        = string
  default     = "https://api.datadoghq.eu/"
}

variable "alert_email" {
  description = "Почта для уведомлений мониторинга"
  type        = string
}
