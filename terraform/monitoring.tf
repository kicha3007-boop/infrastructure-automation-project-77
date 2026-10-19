# Проверка «живости» приложения на каждом сервере: агент Datadog делает HTTP-запрос (http_check),
# монитор срабатывает, если хотя бы один экземпляр не отвечает
resource "datadog_monitor" "app_alive" {
  name    = "App is not responding on {{host.name}}"
  type    = "service check"
  query   = "\"http.can_connect\".over(\"instance:app\").by(\"host\").last(3).count_by_status()"
  message = "Приложение на {{host.name}} не отвечает на HTTP-запросы. @${var.alert_email}"

  monitor_thresholds {
    warning  = 1
    critical = 2
    ok       = 1
  }

  notify_no_data    = true
  no_data_timeframe = 5
  renotify_interval = 30

  tags = ["project:infrastructure-automation", "managed-by:terraform"]
}
