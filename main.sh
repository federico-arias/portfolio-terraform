#terraform init
account_id=$(terraform output -raw account_id)
region=$(terraform output -raw region)
tag="v1.0"
project=$1
dbpassword=$2
dbusername=$3

add_lambda() {
  cp lambda/{api_gateway.tf,s3.tf,lambda.tf} .
  cat lambda/output.tf >> output.tf
  cat lambda/variables.tf.tf >> variables.tf
}

connectdb() {
  psql -h $(terraform output -raw rds_hostname) \
    -p $(terraform output -raw rds_port) \
      -U $(terraform output -raw rds_username) postgres
}


push_frontend() {
  ecr_repo=$(terraform output -raw ecr_repo_frontend)

  aws ecr get-login-password \
    --region ${region} --profile komet | docker login --username AWS \
    --password-stdin ${account_id}.dkr.ecr.${region}.amazonaws.com/${ecr_repo}

  docker build -t ${ecr_repo}:${tag} .

  docker push ${ecr_repo}:${tag}
}

apply() {
  terraform apply \
    -var="project=${project}" \
    -var="db_username=${dbusername}" \
    -var="db_password=${dbpassword}" \
    -var="backend_tag=${tag}" \
    -var="frontend_tag=${tag}" \
    --auto-approve
}
apply
