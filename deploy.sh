#!/bin/bash

set -e  # Exit on any error

ENVIRONMENTS=("blue" "green" "production")
BASE_DIR="./terraform/environments"

for ENV in "${ENVIRONMENTS[@]}"
do
  echo "🔧 Working on environment: $ENV"
  cd "$BASE_DIR/$ENV" || exit 1

  echo "➡️  Initializing Terraform..."
  terraform init

  echo "✅ Validating configuration..."
  terraform validate

  echo "📄 Planning infrastructure..."
  terraform plan -out=tfplan

  # Uncomment this line to actually apply changes
  # echo "🚀 Applying infrastructure..."
  # terraform apply -auto-approve tfplan

  echo "✅ Finished $ENV"
  echo "----------------------------"
  cd - > /dev/null
done

echo "🎉 All environments processed."
