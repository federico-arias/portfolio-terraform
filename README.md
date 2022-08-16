# Introduction

This creates a ECS cluster on Fargate with a backend on `/api` and a
front end on `/app` using ELB. Additionaly, it creates an RDS Postgres
database.

# Usage

## Basic configuration parameters

Modify the following variables in the `terragrunt.hcl` files:

* `region`: The AWS region name.
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
for env in app staging
do
    cd terragrunt/${env} && terragrunt apply
    cd ../..
done
```
