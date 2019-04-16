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
	@vagrant halt
	#susptend

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

#
k8s: ## List kubernetes setup
	@echo "export KUBECONFIG=$(PWD)/cluster/temp/admin.conf"

build-docker: ## Build docker image and push
	@docker build -t cloudkats/simpleapp:v2 -f ./lfd259-k8s-developer/labs/3/app/Dockerfile .
	@docker push cloudkats/simpleapp:v2

############
# Minikube #
############
kube-up: ## Start Minikube cluster
	@minikube start --vm-driver=virtualbox --kubernetes-version=v1.13.5 
	@minikube config set memory 4192
	@minikube config set cpus 2
	@minikube config set heapster true
	@minikube config set ingress true

kub-stop: ## Stop Minikube cluster
	@minikube stop

kube-delete: ## Delete Minikube cluster
	@echo "Deletecluster with minikube"
	@bin/minikube.delete.sh