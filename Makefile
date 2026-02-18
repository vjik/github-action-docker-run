.DEFAULT_GOAL := help

hadolint: ## Run hadolint on the Dockerfile
	docker run --rm -i hadolint/hadolint < Dockerfile

shellcheck: ## Run shellcheck on shell scripts
	docker run --rm -v "$(shell pwd):/mnt" koalaman/shellcheck:stable entrypoint.sh

# Output the help for each task, see https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
