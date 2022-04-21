#!/bin/bash

ecr_frontend_registry=$(terraform output -raw ecr_repo_frontend)
ecr_backend_registry=$(terraform output -raw ecr_repo_backend)
region=$(terraform output -raw region)

for registry in ${ecr_frontend_registry} ${ecr_backend_registry}
do
  t=$(mktemp)
  cp .gitlab-ci.yml $t
  sed -i $(printf 's#__ecr_registry__#%s#g' ${ecr_registry}) $t
  sed -i $(printf 's#__aws_region__#%s#g' ${region}) $t
  cp $t "gitlab-ci${registry#*/}.yml"
done
