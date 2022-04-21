#!/bin/bash

# Adds the files to use a lambda serverless function in the project
add_lambda() {
  cp lambda/{api_gateway.tf,s3.tf,lambda.tf} .
  cat lambda/output.tf >> output.tf
  cat lambda/variables.tf >> variables.tf
}

add_lambda
