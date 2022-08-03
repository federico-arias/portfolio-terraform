project=$(terraform output -raw project)
region=$(terraform output -raw region)
aws_profile=$(terraform output -raw aws_profile)
db_password=eyAicGFzc3dvcmQiOiAiTGF1cmEiIH0=
jwt_secret=eyAicGFzc3dvcmQiOiAiT2N0YXZpYSIgfQ==

aws secretsmanager create-secret \
  --name "${project}-db_password" \
  --description "Postgres password for ${project}" \
  --secret-string $db_password \
  --profile $aws_profile \
  --region $region

exit
# TODO: import the secret as part of the state

terraform import aws_secretsmanager_secret.db_password "${project}-db_password"
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
