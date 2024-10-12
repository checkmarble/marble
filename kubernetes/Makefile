BACKEND_FOLDER := ./marble-backend
CRON_FOLDER := ./marble-cron
FRONT_FOLDER := ./marble-front
APP_NAME := marbe-app


buid:
	helm dependency build $(BACKEND_FOLDER)
	helm dependency build $(CRON_FOLDER)
	helm dependency build $(FRONT_FOLDER)

update-front:
	helm dependency update $(FRONT_FOLDER)

install:
	helm install $(APP_NAME) $(FRONT_FOLDER)

uninstall:
	helm uninstall $(APP_NAME)
