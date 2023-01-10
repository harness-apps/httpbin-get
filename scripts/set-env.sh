#!/usr/bin/env bash

set -eo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ENV_FILE="$SCRIPT_DIR/../.env"

echo -n "" > "$ENV_FILE"
{
echo "REGISTRIES=$(terraform output -raw artifact_registry)"
echo "PLUGIN_IMAGE=$(terraform output -raw repo_url)/my-blogs"
echo "PLUGIN_SERVICE_NAME=my-blogs"
echo "PLUGIN_REGION=$(terraform output -raw region)"
echo "PLUGIN_PROJECT=$(terraform output -raw project_id)"
echo "GOOGLE_APPLICATION_CREDENTIALS=/kaniko/sa.json"
echo "PLUGIN_SERVICE_ACCOUNT_JSON='$(terraform output -raw repo_sa_key | gbase64 -d | jq -r -c )'"
} >> "$ENV_FILE"
