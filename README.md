# Инфраструктура как код

[![hexlet-check](https://github.com/kicha3007-boop/infrastructure-automation-project-77/actions/workflows/hexlet-check.yml/badge.svg)](https://github.com/kicha3007-boop/infrastructure-automation-project-77/actions)

Инфраструктура приложения в Yandex Cloud описана в Terraform, подготовка серверов и деплой — в Ansible.

Учебный проект Хекслета: https://ru.hexlet.io/programs/infrastructure-automation

## Что создаётся

- Две виртуальные машины с приложением (`terraform/compute.tf`)
- Application Load Balancer: HTTPS на 443 с сертификатом Let's Encrypt из Certificate Manager, редирект с 80 на HTTPS (`terraform/balancer.tf`)
- Managed PostgreSQL (`terraform/database.tf`)
- DNS-зона домена и A-запись на балансировщик (`terraform/domain.tf`)
- Монитор Datadog: срабатывает, если приложение на сервере не отвечает на HTTP-запросы агента (`terraform/monitoring.tf`)

Стейт Terraform хранится в бакете Yandex Object Storage (`terraform/backend.tf`), в репозитории его нет.

## Секреты

Все секреты (токен облака, пароль БД, ключи Datadog, SSH-ключ) лежат в зашифрованном `ansible/group_vars/all/vault.yml`. Пароль от него — в файле `.vault_pass` в корне (в репозиторий не попадает).

```bash
echo 'пароль' > .vault_pass
make vault-edit        # отредактировать секреты
make terraform-vars    # Ansible расшифрует vault и сгенерирует terraform/secrets.auto.tfvars
```

Terraform читает секреты только из сгенерированного `secrets.auto.tfvars` и сам ничего не расшифровывает.

## Использование

```bash
cp terraform/backend.secrets.hcl.example terraform/backend.secrets.hcl  # ключи доступа к бакету со стейтом
make setup        # коллекции Ansible, terraform-vars, terraform init
make plan
make apply        # создать инфраструктуру
make output       # адреса серверов, балансировщика, БД и NS-серверы для делегирования домена
```

Адреса серверов из `make output` прописываются в `ansible/inventory.ini`, адрес БД — в `ansible/group_vars/all/vars.yml`.

```bash
make provision    # всё сразу: Docker, приложение, агент Datadog
make prepare      # только установка Docker
make deploy       # только (пере)деплой контейнера приложения
make monitoring   # только агент Datadog с http_check
make destroy      # удалить инфраструктуру
make lint         # terraform fmt и ansible-lint
```

Приложение — образ `hexletcomponents/devops-example-app`, подключённый к Managed PostgreSQL.

## Домен

Домен регистрируется у регистратора и делегируется на NS-серверы Yandex Cloud (`ns1.yandexcloud.net`, `ns2.yandexcloud.net`). Имя домена задаётся переменной `domain` в `ansible/group_vars/all/vars.yml`.

<details>
<summary>Автоматические тесты Хекслета</summary>

Тесты запускаются на каждый коммит. За запуск отвечает файл `.github/workflows/hexlet-check.yml` — не удаляйте и не переименовывайте ни его, ни репозиторий.

</details>
