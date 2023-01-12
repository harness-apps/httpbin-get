#!/usr/bin/env bash

set -eo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ENV_FILE="$SCRIPT_DIR/../delegate/.env"
gcloud_cli_artifact=https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-413.0.0-linux-x86_64.tar.gz
terraform_cli_artifact=https://releases.hashicorp.com/terraform/1.3.7/terraform_1.3.7_linux_amd64.zip

cp "$SCRIPT_DIR/../.keys/harness-tutorial-sa-key.json" "$SCRIPT_DIR/../delegate/"

if [ "$(uname -m)" == "arm64" ];
then
  gcloud_cli_artifact=https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-413.0.0-linux-arm.tar.gz
  terraform_cli_artifact=https://releases.hashicorp.com/terraform/1.3.7/terraform_1.3.7_linux_arm64.zip
fi

echo -n "" > "$ENV_FILE"
{
printf "REGISTRIES=%s\n" "$(terraform output -raw artifact_registry)"
printf "IMAGE=%s\n" "$(terraform output -raw repo_url)/httpbin-get"
printf "SERVICE_NAME=httpbin-get\n"
printf "REGION=%s\n" "$(terraform output -raw region)"
printf "PROJECT=%s\n" "$(terraform output -raw project_id)"
printf "GOOGLE_APPLICATION_CREDENTIALS=/harness-tutorial/harness-tutorial-sa-key.json\n"
printf "GCLOUD_CLI_ARTIFACT=%s\n" "$gcloud_cli_artifact"
printf "TERRAFORM_CLI_ARTIFACT=%s\n" "$terraform_cli_artifact"
} >> "$ENV_FILE"