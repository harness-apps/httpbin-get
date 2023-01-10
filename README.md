# Dictionary Application

A simple demo that simulates <https://httpbin.org/get> call and returns a JSON response.

The container image will be pushed to  [Google Artifact Registry](https://cloud.google.com/artifact-registry/docs/overview) docker repository. Deploy the pushed container image to [Google Cloud Run](https://cloud.google.com/run/docs).

## Pre-Requisites

- [Google Cloud Account](https://cloud.google.com)
- A [Google Service Account](https://cloud.google.com/iam/docs/service-accounts) with permissions to create [Google Artifact Registry](https://cloud.google.com/artifact-registry/docs/overview) registries, service accounts and service account keys.
- [Drone CLI](https://docs.drone.io/cli/install/) to test the pipeline locally
- [jq](https://stedolan.github.io/jq/) to read and trim service account key json

## Clone the sources

```shell
git clone https://github.com/kameshsampath/httpbin-get && cd "$_"
export TUTORIAL_HOME="$PWD"
```

## Deploy Infrastructure

The repository has [terraform](https://terraform.io) scripts that allows you to quickly setup a Google Cloud infrastructure.

The `terraform apply` will,

- [x] Create a Google Artifact Registry repository called `harness-tutorial`
- [x] Create a Google Service Account called `harness-tutorial-sa` with permissions to 
  - [x] Administer the `harness-tutorial` repository
  - [x] Deploy services to Google Cloud Run

The `terraform.tfvars` has all defaults. Edit and update it to suit your Google Cloud settings.

Deploy the infrastructure,

```shell
make init apply
```

On the successful run of the terraform, the service account key file will be generated in the `$TUTORIAL_HOME/.keys/harness-tutorial-sa` folder.

## Build

Set some environment variables to be used with the drone pipeline,

> **NOTE**: When using Harness CI, these environment variables could be added into respective step's `envVariables`

```shell
echo -n "" > .env
{
echo "REGISTRIES=$(terraform output -raw artifact_registry)"
echo "PLUGIN_IMAGE=$(terraform output -raw repo_url)/my-blogs"
echo "PLUGIN_SERVICE_NAME=my-blogs"
echo "PLUGIN_REGION=$(terraform output -raw region)"
echo "PLUGIN_PROJECT=$(terraform output -raw project_id)"
echo "GOOGLE_APPLICATION_CREDENTIALS=/root/sa.json"
echo "PLUGIN_SERVICE_ACCOUNT_JSON='$(terraform output -raw repo_sa_key | base64 -D | jq -r -c )'"
} >> .env
```

> **TIP**: Run $PWD/scripts/set-env.sh to create the `.env`

Let us run the drone pipeline locally to test the infra is setup correctly

```shell
drone exec --env-file=.env --trusted
```

## Cleanup

The following command will destroy all resources that has have been created on Google Cloud.

```shell
cd $TUTORIAL_HOME
make destroy
```

> __NOTE__: The terraform can delete the Cloud Run service, please delete via Google Cloud Console or gcloud cli
> 
