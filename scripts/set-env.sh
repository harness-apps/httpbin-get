#!/usr/bin/env bash

set -eo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ENV_FILE="$SCRIPT_DIR/../.env"

echo -n "" > "$ENV_FILE"
{
echo "REGISTRIES=$(terraform output -raw artifact_registry)"
echo "PLUGIN_IMAGE=$(terraform output -raw repo_url)/httpbin-get"
echo "PLUGIN_SERVICE_NAME=httpbin-get"
echo "PLUGIN_REGION=$(terraform output -raw region)"
echo "PLUGIN_PROJECT=$(terraform output -raw project_id)"
echo "PLUGIN_SERVICE_ACCOUNT_JSON=$(terraform output repo_sa_key)"
} >> "$ENV_FILE"
