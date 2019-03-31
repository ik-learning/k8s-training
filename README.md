# Kubernetes trainings

## Supported Commands

<!-- START makefile-doc -->
```
$ make help 
install                        Install dev dependencies
validate                       Validate multiple files
vagrant-setup                  Prepare vagrant setup
k8s-start                      Start kubernetes cluster (Vagrant)
k8s-stop                       Stop kubernetes cluster (Vagrant)
k8s-destroy                    Destroy kubernetes cluster (Vagrant)
box-ssh                        SSH to Vagrant box. BOX_NAME=master-1 make box_ssh
box-provision                  Provision boxes 
```
<!-- END makefile-doc -->

## Inspired with

[Vagrant K8s Lab](https://github.com/xbernpa/vagrant-kubernetes-lab)
[Vagrang Kubo](https://github.com/rgl/kubernetes-ubuntu-vagrant)