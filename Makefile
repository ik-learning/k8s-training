BUILD_ID := $(shell git rev-parse --short HEAD 2>/dev/null || echo no-commit-id)
.EXPORT_ALL_VARIABLES:

.PHONY: help terraform terraform-docs
.DEFAULT_GOAL := default

default: help

help:
	@cat Makefile* | grep -E '^[a-zA-Z_-]+:.*?## .*$$' | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

#####################
# Setup Environemnt #
#####################
install: ## Install dev dependencies
	@brew bundle
	@pre-commit install
	@pre-commit gc
	@pre-commit autoupdate

###################
# Validate Files #
##################
validate: ## Validate multiple files
	@pre-commit run --all-files