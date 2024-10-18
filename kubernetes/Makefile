APPLICATION_NAME := marble-application
APPLICATION_VERSION := $(shell cat .versions| grep -w "APPLICATION-VERSION" | cut -d: -d'=' -f2)
NAMESPACE := checkmarble
## BACKEND VERSION CONFIGURATION
MARBLE_BACKEND_IMAGE := europe-west1-docker.pkg.dev/marble-infra/marble/marble-backend
#OLD_MARBLE_BACKEND_VERSION := $(shell cat marble/marble-backend/Chart.yaml  | grep -w "version:" | cut -d: -d':' -f2)
MARBLE_BACKEND_VERSION := $(shell cat .versions| grep -w "MARBLE-BACK-IMG" | cut -d: -d'=' -f2)
MARBLE_BACKEND_APP_VERSION := $(shell cat .versions| grep -w "MARBLE-BACK-VERSION" | cut -d: -d'=' -f2)

## FRONTEND VERSION CONFIGURATION
MARBLE_FRONTEND_IMAGE := europe-west1-docker.pkg.dev/marble-infra/marble/marble-frontend
#OLD_MARBLE_FRONTEND_VERSION := $(shell cat marble/marble-front/Chart.yaml  | grep -w "version:" | cut -d: -d':' -f2)
MARBLE_FRONTEND_VERSION := $(shell cat .versions| grep -w "MARBLE-FRONT-IMG" | cut -d: -d'=' -f2)
MARBLE_FRONTEND_APP_VERSION := $(shell cat .versions| grep -w "MARBLE-FRONT-VERSION" | cut -d: -d'=' -f2)

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
	@yq -i '.version="$(MARBLE_BACKEND_APP_VERSION)"' marble/marble-backend/Chart.yaml
	@yq -i '.version="$(MARBLE_BACKEND_APP_VERSION)"' marble/marble-cron/Chart.yaml
	@yq -i '.version="$(MARBLE_FRONTEND_APP_VERSION)"' marble/marble-front/Chart.yaml
	@yq -i '.dependencies |= map(select(.name == "marble-api").version="$(MARBLE_BACKEND_APP_VERSION)")' marble/Chart.yaml
	@yq -i '.dependencies |= map(select(.name == "marble-cron").version="$(MARBLE_BACKEND_APP_VERSION)")' marble/Chart.yaml
	@yq -i '.dependencies |= map(select(.name == "marble-front").version="$(MARBLE_FRONTEND_APP_VERSION)")' marble/Chart.yaml
	@yq -i '.version="$(APPLICATION_VERSION)"' marble/Chart.yaml
	@helm dependency update ./marble

.PHONY: pack
pack: update_dependencies
	@helm plugin install https://github.com/thynquest/helm-pack.git
	@helm pack ./marble --set global.deployment.marbleFront.version=$(MARBLE_FRONTEND_VERSION) \
	--set global.deployment.marbleBack.version=$(MARBLE_BACKEND_VERSION)
	@helm plugin uninstall pack
	

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
