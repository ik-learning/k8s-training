# Kubernetes trainings

## Supported Commands

<!-- START makefile-doc -->
```
$ make help
install                        Install dev dependencies
validate                       Validate multiple files
vagrant-setup                  Prepare vagrant setup
box-up                         Start kubernetes cluster (Vagrant)
box-stop                       Stop kubernetes cluster (Vagrant)
box-destroy                    Destroy kubernetes cluster (Vagrant)
box-provision                  Provision boxes
box-ssh                        SSH to Vagrant box. BOX_NAME=master-1 make box-ssh
box-cache                      Remove Vagrant cache
k8s                            List kubernetes setup
build-docker                   Build docker image and push
minikube-up                    Start Minikube cluster
minikube-delete                Delete Minikube cluster
```
<!-- END makefile-doc -->

## Inspired with

- [Vagrant K8s Lab](https://github.com/xbernpa/vagrant-kubernetes-lab)
- [Vagrang Kubo](https://github.com/rgl/kubernetes-ubuntu-vagrant)
- [K8s The Hard Way](https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/master/docs/04-certificate-authority.md)
- [App Example](https://github.com/ik-learning/vagrant-ubuntu-k8s/tree/master/examples/client/go)
- [K8s Basic](https://kubernetes.io/docs/tutorials/kubernetes-basics/)
- [K8s Vagrant](https://github.com/ereslibre/kubernetes-cluster-vagrant)
- [K8s Networking Policies](https://github.com/ahmetb/kubernetes-network-policy-recipes)
<!-- TODO certificates out. Deploy stuff via worker -->

## To try

[Istio Dashboard](https://github.com/ik-kubernetes/naftis)

## TODO

- Return to lab 3 and setup private registry
https://courses.edx.org/courses/course-v1:LinuxFoundationX+LFS158x+1T2018/course/

## Exercides for CKAD

[CKAD alot](https://github.com/dgkanatsios/CKAD-exercises)
[Kubernetes by Example](http://kubernetesbyexample.com/)
[K8s The Hard Way](https://github.com/kelseyhightower/kubernetes-the-hard-way)
[EKS K8s Workshop](https://github.com/aws-samples/aws-workshop-for-kubernetes)
[GCS K8s Workshop](https://github.com/aws-samples/aws-workshop-for-kubernetes)

## Courses

[Scalable Microservices with Kubernetes](https://eu.udacity.com/course/scalable-microservices-with-kubernetes--ud615)

## Resources

[SpreadSheet](https://docs.google.com/spreadsheets/d/10NltoF_6y3mBwUzQ4bcQLQfCE1BWSgUDcJXy-Qp2JEU/edit#gid=0)

## Editors

[Vim](https://devhints.io/vim)
[Set Vim](https://stackoverflow.com/questions/26962999/wrong-indentation-when-editing-yaml-in-vim)
[VIM cheat sheet](https://vim.rtorr.com/)

## Exam

[Video CKAD](https://www.youtube.com/watch?v=rnemKrveZks&feature=youtu.be)
[Curriculum](https://github.com/cncf/curriculum)

## Chalanges

[K8s Challange](https://github.com/kodekloudhub/kubernetes-challenge-1-wordpress)