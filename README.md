# Introduction

This creates a ECS cluster on Fargate with a backend on `/api` and a
front end on `/app` using ELB. Additionaly, it creates an RDS Postgres
database.

# Usage

## Basic configuration parameters

Modify the following variables in `variables.tf`:

* `region`: The AWS region name.
* `project`: The project name.
* `api_path`: The path of the main API.
* `aws_profile`: The name of the aws profile to use.

## Secrets management

Then, create the following secrets in AWS Secrets Manager:

* `db_password`: The PostgreSQL database password.
* `jwt_secret`: JWT secret.

```bash
$ bash scripts/create_aws_secret.sh <db_password> <jwt_secret>
```

Then, create a ssh key-pair to access the bastion host:

```bash
ssh-keygen -t rsa -b 4096 -C "example@email.com" -f $HOME/.ssh/aws_bastion
```

## Terraform apply

Finally, apply Terraform and get the data for you CI/CD system:

```bash
$ bash scripts/terraform_apply.sh
```

This is the data you'll need:

* `terraform output -raw ecr_repo_backend` - to get the ECR registry.
* `terraform output -raw ecr_repo_frontend` - to get the ECR registry.
* `terraform output -raw aws_id` - to get the ECR registry.
* `terraform output -raw aws_secret` - to get the ECR registry.
* `terraform output -raw region` - to get the AWS region.
