# Kubernetes trainings

## Supported Commands

<!-- START makefile-doc -->
```
$ make help 
install                        Install dev dependencies
validate                       Validate multiple files
vagrant-setup                  Prepare vagrant setup
box-start                      Start kubernetes cluster (Vagrant)
box-stop                       Stop kubernetes cluster (Vagrant)
box-destroy                    Destroy kubernetes cluster (Vagrant)
box-provision                  Provision boxes
box-ssh                        SSH to Vagrant box. BOX_NAME=master-1 make box-ssh
box-cache                      Remove Vagrant cache 
```
<!-- END makefile-doc -->

## Inspired with

[Vagrant K8s Lab](https://github.com/xbernpa/vagrant-kubernetes-lab)
[Vagrang Kubo](https://github.com/rgl/kubernetes-ubuntu-vagrant)
[App Example](https://github.com/ik-learning/vagrant-ubuntu-k8s/tree/master/examples/client/go)