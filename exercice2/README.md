# README

## Dependencies

Packer:
https://developer.hashicorp.com/packer/tutorials/docker-get-started/get-started-install-cli

Terraform:
https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

## How to

```
$ export AWS_ACCESS_KEY_ID="<YOUR_AWS_ACCESS_KEY_ID>"
$ export AWS_SECRET_ACCESS_KEY="<YOUR_AWS_SECRET_ACCESS_KEY>"
$ export AWS_DEFAULT_REGION="eu-west-1"
$ cd packer
$ packer init .
$ packer build node-todo.pkr.hcl
$ cd ../terraform
$ terraform init
$ terraform apply
```

## What is missing on production

 * CI/CD
 * Alterting
 * Monitoring
 * SG configuration
 * Using private subnet
 * Increase ASG size
 * Backups
 * Deploy Mongo on saas

## Other options

### Docker

Pros

 * easier if you have already an orchestrator (K8s,Nomad,...)
 * more common
 * little better isolation
 * scale up is faster
 * easier to plug monitoring and logging
 
Cons

 * bad network performance
 * bad memory limit management through cgroups
 * harder to debug
 * not neccessarly the best option in all cases

### Pulumi

Pros

 * more flexible than TF
 * opensource
 * easier for automation

Cons

 * less use

