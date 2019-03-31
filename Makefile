BUILD_ID := $(shell git rev-parse --short HEAD 2>/dev/null || echo no-commit-id)
VAGRANT_CWD=./cluster/

.EXPORT_ALL_VARIABLES:

.PHONY: help terraform terraform-docs vagrant start start_k8s

.DEFAULT_GOAL := help

help:
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

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

###########
# Vagrant #
###########
vagrant-setup: ## Prepare vagrant setup
	@vagrant plugin update
	@vagrant plugin install vagrant-hostmanager
	@vagrant plugin install vagrant-share
	@vagrant plugin install vagrant-cachier
	@vagrant plugin list

#################
# Vagrant Boxes #
#################
box-up: ## Start kubernetes cluster (Vagrant)
	@echo "Deploy cluster with vagrant ${VAGRANT_CWD}"
	@vagrant up

box-stop: ## Stop kubernetes cluster (Vagrant)
	@echo "Stop cluster with vagrant ${VAGRANT_CWD}"
	@vagrant stop

box-destroy: ## Destroy kubernetes cluster (Vagrant)
	@echo "Destroy cluster with vagrant ${VAGRANT_CWD}"
	@vagrant destroy --force --parallel

box-provision: ## Provision boxes
	@echo "Provision boxes"
	@vagrant provision

box-ssh: ## SSH to Vagrant box. BOX_NAME=master-1 make box-ssh
	@echo "SSH onto ${BOX_NAME}"
	@vagrant ssh ${BOX_NAME}

box-cache: ## Remove Vagrant cache
	@echo "Clean Vagrant cache"
	@rm -rf $HOME/.vagrant.d/cache/
	@rm -rf .vagrant/machines/
