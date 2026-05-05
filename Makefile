.PHONY: help build clean test publish ci docker-login generate-docs

# Override these on the command line if you fork to a different namespace.
NAMESPACE ?= doughatcher/devcontainer-templates
REGISTRY  ?= ghcr.io

help: ## Show this help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

build: clean build-magento ## Build all devcontainers

build-magento: ## Build the magento devcontainer
	devcontainer up --workspace-folder src/magento --remove-existing-container

generate-docs: ## generate docs for each devcontainer
	devcontainer templates generate-docs -p src/

publish: clean docker-login ## publish all devcontainers to GHCR
	devcontainer templates publish -r $(REGISTRY) -n $(NAMESPACE) ./src

ci: build publish ## Build and publish all devcontainers

docker-login: ## performs the correct login to ghcr.io for publishing
	echo $$GITHUB_TOKEN | docker login $(REGISTRY) -u USERNAME --password-stdin

clean: ## clean files from devcontainers before publishing
	git clean -Xd -f src/**
