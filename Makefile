SHELL := /bin/bash

## Avoid using the double quotes with value
APP_NAME := tictactoe
VERSION := 1.0
KIND_CLUSTER := local-test-eu-west-1-tictactoe-app
DOCKER_IMAGE := golang
DOCKER_IMAGE_TAG := 1.21
GO_CMD := go

DOCKER_RUN := docker run --rm -v ${PWD}:/usr/src/${APP_NAME} -w /usr/src/${APP_NAME} ${DOCKER_IMAGE}:${DOCKER_IMAGE_TAG}

update-deps:
	@echo "Updating all the dependencies in go.mod file"
	$(DOCKER_RUN) $(GO_CMD) get -u -t -v ./...

.PHONY: tidy

## Adding tidy as Fake, as there is a possibility that a file named tidy could
## be present
tidy:
	$(DOCKER_RUN) $(GO_CMD) mod tidy
	$(DOCKER_RUN) $(GO_CMD) mod vendor

build:
	$(DOCKER_RUN) /bin/sh -c 'export GOCOVERDIR="reports/_icoverdir_" && export CGO_ENABLED=0 && $(GO_CMD) generate && $(GO_CMD) build -installsuffix cgo -o bin/"${APP_NAME}" -cover -v'

cleanbuild-verbose:
	@CGO_ENABLED=0 GOCOVERDIR="reports/_icoverdir_" go build -a -x -installsuffix cgo -tags generate -o bin/"${APP_NAME}" -cover -v 

cleanbuild:
	@CGO_ENABLED=0 GOCOVERDIR="reports/_icoverdir_" go build -a -installsuffix cgo -tags generate -o bin/"${APP_NAME}" -cover 

run:
	$(DOCKER_RUN) $(GO_CMD) run main.go

cov-reports:
	$(DOCKER_RUN) $(GO_CMD) tool covdata textfmt -i "reports/_icoverdir_" -o "reports/coverage/coverage.out"

# TODO: Provide all the build arguments for the docker image
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

kind-show-cluster:
	kind get clusters

kind-show-context:
	kubectl config current-context
	kubectl config get-contexts

kind-show-all: kind-show-cluster kind-show-context
	
kind-info:
	kind get clusters
	kubectl cluster-info --context kind-${KIND_CLUSTER}

kind-load:
	kind load docker-image tictactoe-service:"${VERSION}"  --name "${KIND_CLUSTER}"

kind-apply:
	kustomize build fence/k8s/kind/tictactoe-pod | kubectl apply -f -

kind-down:
	kind delete cluster --name "${KIND_CLUSTER}"

kind-status:
	kubectl get nodes -o wide
	kubectl get pods -o wide
	kubectl get svc -o wide

kind-status-tictactoe:
	kubectl get pods -o wide --namespace=tictactoe-system

kind-logs:
	kubectl logs -v=7 -l app=tictactoe --all-containers=true -f --tail=100 --namespace=tictactoe-system

kind-restart:
	kubectl rollout restart deployment tictactoe-pod --namespace=tictactoe-system

kind-describe:
	kubectl describe pod -l app=tictactoe

kind-start: service kind-init kind-load kind-apply

kind-clean-start: kind-down service kind-init kind-load kind-apply

kind-update: service kind-load kind-restart

kind-update-apply: service kind-load kind-apply
