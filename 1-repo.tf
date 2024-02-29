resource "google_secret_manager_secret" "secret" {
  secret_id = "gh-secret-test"
  replication {
    auto {}
  }
}

resource "github_repository" "gh-repo" {
  count = length( var.github-new-repo ? [1] : [] )
  name = var.github-repo
  visibility = "public"
}

data "github_repository" "gh-repo-data" {
  count = length( var.github-new-repo ? [] : [1] )
  name = var.github-repo
}

resource "google_secret_manager_secret_version" "gsp-secret-val" {
  secret = google_secret_manager_secret.secret.id
  secret_data = var.github-oauth-token
}

resource "google_cloudbuildv2_connection" "gc-conn-github" {
  location = "us-central1"
  name = "github-conn-p"

  github_config {
    app_installation_id = var.github-app-installation-id
    
    authorizer_credential {
      oauth_token_secret_version = google_secret_manager_secret_version.gsp-secret-val.name
    }
  }
}

resource "google_cloudbuildv2_repository" "gh-repo" {
    name = "gh-repo"
    parent_connection = google_cloudbuildv2_connection.gc-conn-github.id
    remote_uri = var.github-new-repo ? github_repository.gh-repo[0].http_clone_url : data.github_repository.gh-repo-data[0].http_clone_url
}