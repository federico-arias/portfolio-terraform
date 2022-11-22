# Introduction

This creates a Kubernetes cluster on EKS. Additionaly, it creates an RDS Postgres
database.

# Usage

## Basic configuration parameters

Modify the following variables in the `terragrunt.hcl` files:

* `aws_region`: The AWS region name.
* `project`: The project name.
* `aws_profile`: The name of the aws profile to use.
* `domain`: The DNS domain.
* `subdomain`: The DNS subdomain.

Create a ssh key-pair to access the bastion host:

```bash
ssh-keygen -t rsa -b 4096 -C "example@email.com" -f $HOME/.ssh/aws_bastion
```

## Terraform apply

```bash
for env in common app staging
do
    cd terragrunt/${env} && terragrunt apply --force
    cd ../..
done
```

Then, once you have created an Ingress rule in the cluster, come back
and modify the `alb_url` parameter.

To update the Kubernetes config for your cluster, do:

```bash
aws eks \
    --region $(terragrunt output --terragrunt-no-auto-init aws_region) \
    update-kubeconfig \
    --name $(terragrunt output --terragrunt-no-auto-init cluster_name)
```
