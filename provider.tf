terraform {
  required_providers {
    google = {
        version = "5.18.0"
    }

    github = {
      source = "integrations/github"
      version = "6.0.0"
    }
  }

  backend "gcs" {
    bucket = "gcs-state-cicd"
    prefix = "terraform/state"
  }
}

provider "google" {
  alias = "impersonation"
  scopes = [
    "https://www.googleapis.com/auth/cloud-platform",
    "https://www.googleapis.com/auth/userinfo.email",
  ]
}

data "google_service_account_access_token" "svc-impersonation" {
  provider = google.impersonation
  target_service_account = "test-348@ancient-edition-414210.iam.gserviceaccount.com"
  scopes = [ 
    "https://www.googleapis.com/auth/cloud-platform"
  ]

  lifetime = "3600s"
}

provider "google" {
  access_token = data.google_service_account_access_token.svc-impersonation.access_token
  project = var.project
}

# Configure the GitHub Provider
provider "github" {
  token = var.github-oauth-token
}
