#!/bin/bash

# Gets a connection to the bastion host
bastion() {
  # you need a ssh key to access the bastion host
  # ssh-keygen -t rsa -b 4096 -C "federicoariasr@gmail.com" -f $HOME/.ssh/aws_bastion

  ssh -i /home/federico/.ssh/aws_bastion ec2-user@$(terraform output -raw bastion_public_ip)
  # tunnels to database
}
bastion
