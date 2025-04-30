#!/bin/bash

# cleanup_env.sh
# Usage: ./cleanup_env.sh blue OR ./cleanup_env.sh green

set -e

if [ "$#" -ne 1 ]; then
  echo "❌ Usage: $0 <blue|green>"
  exit 1
fi

ENV_TO_CLEAN=$1
VALID_ENVS=("blue" "green")

if [[ ! " ${VALID_ENVS[@]} " =~ " ${ENV_TO_CLEAN} " ]]; then
  echo "❌ Invalid environment. Must be 'blue' or 'green'."
  exit 1
fi

echo "🔍 Fetching active environment from production outputs..."
cd terraform/environments/production
terraform init -input=false > /dev/null
ACTIVE_ENV=$(terraform output -json | jq -r '.active_target_group.value')

if [ "$ACTIVE_ENV" == "$ENV_TO_CLEAN" ]; then
  echo "🚫 Cannot destroy active environment ($ENV_TO_CLEAN)."
  exit 1
fi

cd ../"$ENV_TO_CLEAN"
echo "🧨 Destroying $ENV_TO_CLEAN environment..."
terraform init -input=false
terraform destroy -auto-approve
echo "✅ $ENV_TO_CLEAN environment destroyed successfully."
