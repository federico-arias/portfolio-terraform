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

Finally, apply Terraform and get the data for you CI/CD system:

```bash
$ terraform apply
```

This is the data you'll need:

* `terraform output -raw ecr_repo_backend` - to get the ECR registry.
* `terraform output -raw ecr_repo_frontend` - to get the ECR registry.
* `terraform output -raw aws_id` - to get the ECR registry.
* `terraform output -raw aws_secret` - to get the ECR registry.
