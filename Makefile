VAULT = --vault-password-file $(CURDIR)/.vault_pass

# Подготовка: коллекции Ansible, переменные Terraform из vault, инициализация Terraform со стейтом в Object Storage
setup: install terraform-vars init

install:
	cd ansible && ansible-galaxy collection install -r requirements.yml

terraform-vars:
	cd ansible && ansible-playbook terraform.yml $(VAULT)

init:
	terraform -chdir=terraform init -backend-config=backend.secrets.hcl

plan:
	terraform -chdir=terraform plan

apply:
	terraform -chdir=terraform apply

destroy:
	terraform -chdir=terraform destroy

output:
	terraform -chdir=terraform output

# Деплой на созданную инфраструктуру; отдельные этапы — make prepare / deploy / monitoring
provision:
	cd ansible && ansible-playbook playbook.yml $(VAULT)

prepare deploy monitoring:
	cd ansible && ansible-playbook playbook.yml --tags $@ $(VAULT)

vault-edit:
	ansible-vault edit ansible/group_vars/all/vault.yml $(VAULT)

lint:
	terraform -chdir=terraform fmt -check -recursive
	cd ansible && ansible-lint

.PHONY: setup install terraform-vars init plan apply destroy output provision prepare deploy monitoring vault-edit lint
