locals {
  docker_registry = google_artifact_registry_repository.gartifact-registry.name
}

resource "google_cloudbuild_trigger" "gcp-trigger" {
    name = "cloudbuild-trigger-gitops"
    location = "us-central1"

    repository_event_config {
        repository = google_cloudbuildv2_repository.gh-repo.id

        push {
          branch = ".*"
        }
    }

    git_file_source {
      path = "pipe/ci/cloudbuild.yaml"
      uri = "https://github.com/Siakoo0/tf-gitops.git"
      repo_type = "GITHUB"
    }

    substitutions = {
      _IMAGE_NAME = "us-central1-docker.pkg.dev/${var.project}/${local.docker_registry}/terraform-build"
    }
}