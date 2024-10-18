APPLICATION_NAME := marble-application
APPLICATION_VERSION := 0.1.0
NAMESPACE := checkmarble
MARBLE_BACKEND_IMAGE := europe-west1-docker.pkg.dev/marble-infra/marble/marble-backend
MARBLE_BACKEND_VERSION := v0.1.22
MARBLE_FRONTEND_IMAGE := europe-west1-docker.pkg.dev/marble-infra/marble/marble-frontend
MARBLE_FRONTEND_VERSION := v0.1.24

.PHONY: create_cluster
create_cluster:
	@kind create cluster --config kind-cluster-config.yaml --name marble 

.PHONY: delete_cluster
delete_cluster:
	@kind delete cluster --name marble

.PHONY: pull_images
pull_images:
	@docker pull $(MARBLE_BACKEND_IMAGE):$(MARBLE_BACKEND_VERSION) --platform=linux/amd64
	@docker pull $(MARBLE_FRONTEND_IMAGE):$(MARBLE_FRONTEND_VERSION) --platform=linux/amd64

.PHONY: upload_images
upload_images: pull_images
	@kind load docker-image $(MARBLE_BACKEND_IMAGE):$(MARBLE_BACKEND_VERSION)   --name  marble
	@kind load docker-image $(MARBLE_FRONTEND_IMAGE):$(MARBLE_FRONTEND_VERSION) --name  marble

.PHONY: update_dependencies
update_dependencies:
	@helm dependency update ./marble

.PHONY: pack
pack: update_dependencies
	@helm package ./marble

.PHONY: install
install: pack
	@kubectl create namespace $(NAMESPACE) --dry-run=client -o yaml | kubectl apply -f -
	@helm upgrade -i $(APPLICATION_NAME)  $(APPLICATION_NAME)-$(APPLICATION_VERSION).tgz
	
.PHONY: uninstall
uninstall:
	@helm uninstall $(APPLICATION_NAME)
	@kubectl delete namespace $(NAMESPACE)
	@docker rmi $(MARBLE_BACKEND_IMAGE):$(MARBLE_BACKEND_VERSION)
	@docker rmi $(MARBLE_FRONTEND_IMAGE):$(MARBLE_FRONTEND_VERSION)
	


## for maintenance purpose only

.PHONY: lint
lint:
	@helm lint ./charts

.PHONY: list_k8s-contexts
list_k8s-contexts:
	@kubectl config get-contexts

.PHONY: set_k8s-context
set_k8s-context:
	@kubectl config use-context kind-marble

.PHONY: show_loaded_images
show_loaded_images:
	@docker exec -it marble-worker crictl images
