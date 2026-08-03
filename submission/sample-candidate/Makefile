APP_NAME := config-service
IMAGE := $(APP_NAME):latest
CLUSTER_NAME := config-service
NAMESPACE := config-service

.PHONY: bootstrap platform build load deploy up down test smoke

bootstrap:
	cd infra/terraform/bootstrap && terraform init
	cd infra/terraform/bootstrap && terraform validate
	cd infra/terraform/bootstrap && terraform init && terraform apply -auto-approve

platform:
	cd infra/terraform/platform && terraform init
	cd infra/terraform/platform && terraform validate
	cd infra/terraform/platform && terraform init && terraform apply -auto-approve

build:
	docker build -t $(IMAGE) .

load:
	kind load docker-image $(IMAGE) --name $(CLUSTER_NAME)

deploy:
	kubectl apply -f k8s

up: bootstrap platform build load deploy

test:
	go test ./... -v

smoke:
	kubectl wait --for=condition=Available deployment/$(APP_NAME) -n $(NAMESPACE) --timeout=120s
	kubectl wait --for=condition=Ready pod -l app=$(APP_NAME) -n $(NAMESPACE) --timeout=120s
	kubectl wait --for=condition=Ready pod -l app=postgres -n $(NAMESPACE) --timeout=120s
	kubectl get pods -n $(NAMESPACE)
	kubectl get svc -n $(NAMESPACE)

down:
	cd infra/terraform/platform && terraform destroy -auto-approve
	cd infra/terraform/bootstrap && terraform destroy -auto-approve