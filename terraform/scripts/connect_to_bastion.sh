#!/bin/bash
terraform refresh -var="db_password=itdoesntmatter" 1> /dev/null

region=$(terraform output -raw region)
project=$(terraform output -raw project)
aws_profile=$(terraform output -raw aws_profile)
BASTION_HOSTNAME=$(terraform output -raw bastion_public_ip)
DB_HOSTNAME=$(terraform output -raw rds_hostname)
DB_PORT=1414
SSH_IDENTITY_FILE="${HOME}/.ssh/aws_bastion"

# Gets a connection to the bastion host
init_bastion() {
	# We generate a ssh key to access the bastion host.
	ssh-keygen -t rsa -b 4096 -C "federicoariasr@gmail.com" -f $SSH_IDENTITY_FILE

	# ec2-user is the default user for this image, but it varies from AMI to AMI.
	ssh -i $SSH_IDENTITY_FILE ec2-user@$(terraform output -raw bastion_public_ip)
}

get_connection_string() {
	# get secrets from secretmanager
	db_password=$(aws secretsmanager \
		get-secret-value \
		--profile ${aws_profile} \
		--region ${region} \
		--secret-id "${project}-db_password" | jq --raw-output '.SecretString')

	db_username="panda"

	db_connection="postgres://${db_username}:${db_password}@localhost:${DB_PORT}/postgres"

	echo -n ${db_connection}
}

# Uses the bastion as tunnel to database in private net.
create_tunnel() {
	echo "Warning: killing everything on port ${DB_PORT}"
	lsof -ti "tcp:${DB_PORT}" | xargs kill -9

	ssh -i $SSH_IDENTITY_FILE ec2-user@${BASTION_HOSTNAME} \
		-N -f -L $DB_PORT:${DB_HOSTNAME}:5432
	SSH_PID=$!

	echo "Bastion connected and listening on port ${DB_PORT}. PID: $SSH_PID"

	conn_string=$(get_connection_string)

	echo "Connecting to ${conn_string}."

	psql $conn_string
}

on_exit() {
	echo "Killing process $SSH_PID"
	kill -9 $SSH_PID
	exit
}

trap on_exit SIGINT SIGTERM

create_tunnel
