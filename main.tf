provider "google" {
  project = var.project_id
  region  = var.region
}

data "google_artifact_registry_repository" "repo-status" {
  location      = var.region
  repository_id = var.repository_id
}

resource "google_artifact_registry_repository" "my-docker-repo" {
  provider = google-beta

  location      = var.region
  repository_id = var.repository_id
  description   = var.repository_description
  format        = "DOCKER"

}

resource "google_service_account" "repo-account" {
  provider = google-beta

  account_id   = var.repo_sa
  display_name = "Repository Service Account"
}

resource "google_service_account_key" "repo-account-key" {
  service_account_id = google_service_account.repo-account.name
}

resource "google_artifact_registry_repository_iam_member" "repo-iam" {
  provider = google-beta

  for_each   = toset(var.repo_sa_roles)
  location   = google_artifact_registry_repository.my-docker-repo.location
  repository = google_artifact_registry_repository.my-docker-repo.name
  member     = google_service_account.repo-account.member
  role       = each.key
}

resource "google_project_iam_binding" "repo-iam-binding" {
  for_each = toset(var.repo_sa_roles)
  project  = var.project_id
  role     = each.key
  members = [
    google_service_account.repo-account.member,
  ]
}

resource "local_sensitive_file" "repo-key-file" {
  content              = base64decode(google_service_account_key.repo-account-key.private_key)
  filename             = "${path.module}/.keys/${var.repo_sa}-key.json"
  file_permission      = "0600"
  directory_permission = "0700"
}