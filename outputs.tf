output "region" {
  value       = var.region
  description = "Google Cloud Region"
}

output "project_id" {
  value       = var.project_id
  description = "Google Project ID"
}

output "artifact_registry" {
  value       = "${var.region}-docker.pkg.dev"
  description = "The created artifact registry"
}

output "repo_url" {
  value       = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.my-docker-repo.name}"
  description = "The the docker repository url"
}

output "repo_sa_key" {
  value       = google_service_account_key.repo-account-key.private_key
  description = "The Service Account JSON Key"
  sensitive   = true
}

