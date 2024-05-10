# README

## Requirements

* install helm:

https://helm.sh/docs/intro/install/

* install minikube

https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/

## Installation

```
$ minikube start
$ cd helm
$ helm install . --values values.yaml
```

## What is missing on production

 * a real Kubernetes server like EKS,GKE,..
 * reverse proxy/network
 * CI/CD
 * Alterting
 * Monitoring

## Other options

### using kustomize instead of Helm

Pros

* official Kube project

Cons

* no templating support (need to code a wrapper to do it)

## using helm + kustomize

Probably the best option but I never use it. Need to be tested.
