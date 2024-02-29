resource "google_artifact_registry_repository" "gartifact-registry" {
  location = "us-central1"
  repository_id = "docker-cicd-prova"
  format = "DOCKER"
}