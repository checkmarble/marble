BACKEND_FOLDER := ./marble-backend
CRON_FOLDER := ./marble-cron
FRONT_FOLDER := ./marble-front
APP_NAME := marble-app
CRON_APP_NAME := marble-cron
MARBLE_BACKEND_IMAGE := europe-west1-docker.pkg.dev/marble-infra/marble/marble-backend
MARBLE_BACKEND_LOCAL_IMAGE := marble-backend
MARBLE_BACKEND_VERSION := v0.1.22
MARBLE_FRONTEND_IMAGE := europe-west1-docker.pkg.dev/marble-infra/marble/marble-frontend
MARBLE_FRONTEND_LOCAL_IMAGE := europe-west1-docker.pkg.dev/marble-infra/marble/marble-frontend
MARBLE_FRONTEND_VERSION := v0.1.24

.PHONY: create_cluster
create_cluster:
	kind create cluster --config kind-cluster-config.yaml --name marble 

.PHONY: delete_cluster
delete_cluster:
	@kind delete cluster --name marble

.PHONY: upload_images
upload_images:
	@kind load docker-image $(MARBLE_BACKEND_IMAGE):$(MARBLE_BACKEND_VERSION)   --name  marble
	@kind load docker-image $(MARBLE_FRONTEND_IMAGE):$(MARBLE_FRONTEND_VERSION) --name  marble

.PHONY: build_dependencies
build_dependencies:
	@helm dependency build $(BACKEND_FOLDER)
	@helm dependency build $(CRON_FOLDER)
	@helm dependency build $(FRONT_FOLDER)

.PHONY: update_dependencies
update_dependencies:
	@helm dependency update $(BACKEND_FOLDER)
	@helm dependency update $(CRON_FOLDER)
	@helm dependency update $(FRONT_FOLDER)

.PHONY: install
install:
	@kubectl create namespace checkmarble --dry-run=client -o yaml | kubectl apply -f -
	@helm upgrade -i $(APP_NAME) $(FRONT_FOLDER) 
	#@helm upgrade -i $(CRON_APP_NAME) $(CRON_FOLDER) 


.PHONY: uninstall
uninstall:
	@helm uninstall $(APP_NAME)
	@helm uninstall $(CRON_APP_NAME)


## for maintenance purpose only

.PHONY: list_k8s-contexts
list_k8s-contexts:
	@kubectl config get-contexts

.PHONY: set_k8s-context
set_k8s-context:
	@kubectl config use-context kind-marble

.PHONY: show_loaded_images
show_loaded_images:
	@docker exec -it marble-worker crictl images
