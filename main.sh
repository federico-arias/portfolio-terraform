#terraform init
account_id=$(terraform output -raw account_id)
region=$(terraform output -raw region)
profile="komet"
tag="v1.6"
project=testing00
dbusername="federico"
dbpassword=12345678

add_secret () {
  secret_name=$1
  secret_value=$2
  secret_id="${project}-$secret_name"
  aws secretsmanager put-secret-value \
    --secret-id "$secret_id" "$dbpassword" \
    --profile $profile \
    --region $region

  terraform import aws_secretsmanager_secret.db_password "$secret_id"
  # get secret id from state
  terraform state show aws_secretsmanager_secret.db_password
  # get version id
  version_id=$(aws secretsmanager list-secret-version-ids \
    --secret-id "$secret_id" \
    --profile $profile \
    --region $region | jq '.Versions[0].VersionId')

  arn=$(aws secretsmanager list-secret-version-ids \
    --secret-id "$secret_id" \
    --profile $profile \
    --region $region | jq '.ARN')

  # import secret version
  $secret_version_id="${version_id}|${arn}"
  terraform import aws_secretsmanager_secret_version.current $secret_version_id
  terraform state show aws_secretsmanager_secret_version.current

  ssh-keygen -t rsa -b 4096 -C "federicoariasr@gmail.com" -f $HOME/.ssh/aws_bastion
}

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

bastion() {
  ssh -i /home/federico/.ssh/aws_bastion ec2-user@$(terraform output -raw bastion_public_ip)
}

push_images() {
  ecr_repo=$(terraform output -raw ecr_repo_backend)

  aws ecr get-login-password \
    --region ${region} --profile "${profile}" | docker login --username AWS \
    --password-stdin ${account_id}.dkr.ecr.${region}.amazonaws.com/${ecr_repo}

  for env in "frontend" "backend"
  do
    ecr_repo=$(terraform output -raw ecr_repo_${env})

    docker build -f /home/federico/proyectos/limehome/${env}/Dockerfile -t ${ecr_repo}:${tag} /home/federico/proyectos/limehome/${env}

    docker push ${ecr_repo}:${tag}
  done

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
