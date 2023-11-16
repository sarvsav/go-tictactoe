SHELL := /bin/bash

APP_NAME := "tictactoe"
VERSION := 1.0
KIND_CLUSTER := "local-test-eu-west-1-tictactoe-app"

update-deps:
	@echo "Updating all the dependencies in go.mod file"
	go get -u -t -v ./...

build:
	export GOCOVERDIR="reports/_icoverdir_"
	export CGO_ENABLED=0
	go generate
	go build -installsuffix cgo -o bin/"${APP_NAME}" -cover -v

cleanbuild:
	export GOCOVERDIR="reports/_icoverdir_"
	CGO_ENABLED=0
	go generate
	go build -a -installsuffix cgo -o bin/"${APP_NAME}" -cover -v

run:
	go run main.go

cov-reports:
	go tool covdata textfmt -i "reports/_icoverdir_" -o "reports/coverage/coverage.out"

service:
	docker build \
		-f fence/docker/Dockerfile \
		-t "${APP_NAME}"-service:${VERSION} \
		--build-arg BUILD_DATE="$(date -u +"%Y-%m-%dT%H:%M:%SZ")" \
		.

kind-init:
	kind create cluster \
		--image kindest/node:v1.28.0 \
		--name "${KIND_CLUSTER}" \
		--config fence/k8s/kind/kind-config.yaml

kind-load:
	kind load docker-image tictactoe-service:"${VERSION}"  --name "${KIND_CLUSTER}

kind-apply:


kind-down:
	kind delete cluster --name "${KIND_CLUSTER}

kind-status:
	kubectl get nodes -o wide
	kubectl get pods -o wide
	kubectl get svc -o wide
