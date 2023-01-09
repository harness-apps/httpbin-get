variable "project_id" {
  description = "project id"
}

variable "region" {
  description = "the region or zone where the cluster will be created"
  default     = "asia-south1"
}

variable "repository_id" {
  description = "the Google Cloud Artifactory Repository ID"
  default     = "my-demos"
}

variable "repository_description" {
  description = "the Google Cloud Artifactory Repository description"
  default     = "my docker repository"
}

variable "repo_sa" {
  description = "the repo admin account"
  default     = "repo-sa"
}

variable "repo_sa_roles" {
  # possible values gcloud iam roles list | grep -i artifactRegistry
  description = "The roles to assign to the repository sa"
  type        = list(string)
  default = [
    "roles/artifactregistry.reader",
  ]
}