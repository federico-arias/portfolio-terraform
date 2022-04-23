#!/bin/bash

# Gets a connection to the bastion host
bastion() {
  # you need a ssh key to access the bastion host
  # ssh-keygen -t rsa -b 4096 -C "federicoariasr@gmail.com" -f $HOME/.ssh/aws_bastion

  ssh -i /home/federico/.ssh/aws_bastion ec2-user@$(terraform output -raw bastion_public_ip)
}

# tunnels to database
create_tunnel() {
  DB_PORT=1414

  ssh -i /home/federico/.ssh/aws_bastion ec2-user@$(terraform output -raw bastion_public_ip) \
    -N -f -L $DB_PORT:$(terraform output -raw rds_hostname):5432
  psql --dbname=postgres \
    --host=localhost \
    --port=$DB_PORT \
    --username=panda \
    --password
}
bastion
