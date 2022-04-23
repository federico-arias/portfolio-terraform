terraform refresh -var="db_password=itdoesntmatter" \

account_id=$(terraform output -raw account_id)
region=$(terraform output -raw region)
project=$(terraform output -raw project)
backend_tag=$(terraform output -raw backend_tag)
frontend_tag=$(terraform output -raw frontend_tag)
aws_profile=$(terraform output -raw aws_profile)


# TODO: move this to a CI/CD, secrets come from env vars, tags from git tags.
apply() {
  # get secrets from secretmanager
  db_password=$(aws secretsmanager \
    get-secret-value \
    --profile ${aws_profile} \
    --region ${region} \
    --secret-id "${project}-db_password" | jq --raw-output '.SecretString')


  terraform apply \
    -var="project=${project}" \
    -var="db_password=${db_password}" \
    -var="backend_tag=${backend_tag}" \
    -var="frontend_tag=${frontend_tag}" \
    -replace="aws_ecs_task_definition.backend" \
    -replace="aws_ecs_task_definition.frontend"
}

apply
