project_id = slack-bier-$(WORKSPACE_ID)
project_name = "BierCommand-$(WORKSPACE_ID)"

.PHONY: check-workspace check-email check-slack check-api create-project deploy

deploy: check-workspace check-email check-slack check-api create-project
	gcloud config set project $(project_id)
	gcloud functions deploy \
		--allow-unauthenticated \
		--project=$(project_id) \
		--runtime=go113 \
		--set-env-vars=SLACK_TOKEN=$(SLACK_TOKEN),API_KEY=$(API_KEY) \
		--trigger-http \
		Bier

create-project:
	gcloud projects create \
		--name=$(project_name) \
		--enable-cloud-apis $(project_id) || true
	sleep 10

check-workspace:
ifndef WORKSPACE_ID
	$(error "You must set WORKSPACE_ID)
	exit 1
endif

check-email:
ifndef EMAIL
	$(error "You must set EMAIL)
	exit 1
endif

check-slack:
ifndef SLACK_TOKEN
	$(error "You must set SLACK_TOKEN)
	exit 1
endif

check-api:
ifndef API_KEY
	$(error "You must set API_KEY)
	exit 1
endif
