.PHONY: help
.DEFAULT_GOAL := help

# Self-documenting makefile compliments of François Zaninotto http://bit.ly/2PYuVj1

distro  := ubuntu
version := $(shell grep VERSION Dockerfile | cut -d\  -f 3)

help:
	@echo "Make targets for Docker Carbon-C-Relay:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build-image: ## Build the Docker Carbon-C-Relay from Dockerfile
	@docker build . -t gtrummellquizlet/carbon-c-relay:$(version) -t gtrummellquizlet/carbon-c-relay:latest

clean: ## Sanitize the workspace
	-docker rmi -f gtrummellquizlet/carbon-c-relay:latest
	-docker rmi -f gtrummellquizlet/carbon-c-relay:$(version)

get-deps: ## Retrieve dependencies
	@docker pull $(distro):$(version)

push-image: ## Push the Docker Carbon-C-Relay to Dockerhub
	docker push gtrummellquizlet/carbon-c-relay:latest && \
	docker push gtrummellquizlet/carbon-c-relay:$(version)

test-dockerfile: ## Test the Docker Carbon-C-Relay Dockerfile
	@docker run -i --rm hadolint/hadolint < Dockerfile

ci: clean get-deps test-dockerfile build-image ## Run all tests and build an image without pushing it to Dockerhub

cd: ci push-image ## Push the Docker Carbon-C-Relay to Dockerhub (alias of push-image)
