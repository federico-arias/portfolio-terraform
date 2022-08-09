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

Create a ssh key-pair to access the bastion host:

```bash
ssh-keygen -t rsa -b 4096 -C "example@email.com" -f $HOME/.ssh/aws_bastion
```

## Import shared resources

```bash
terragrunt import aws_ecr_repository.backend <name>
terragrunt import aws_ecr_repository.backend <name>
terragrunt import cloudflare_record.validation <zone-id>/<record-id>
```

## Terraform apply

Finally, apply Terraform and get the data for you CI/CD system:

```bash
$ cd terragrunt/production && terragrunt apply
```

# TODO

* Create lambda to execute migration, set DATABASE_URL and execute

```bash
aws lambda invoke \
    --function-name my-function \
    --invocation-type Event \
    --payload '{ "name": "Bob" }' \
    response.json
```

https://github.com/prisma/prisma/issues/2980#issuecomment-665691866
