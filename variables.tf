variable "project" {}

variable "apis" {
    type = list(string)
    default = [ 
        "clouddeploy.googleapis.com", 
        "cloudbuild.googleapis.com",
        "sourcerepo.googleapis.com"
    ]
}

variable "github-repo" {}
variable "github-oauth-token" {}
variable "github-app-installation-id" {}

variable "github-new-repo" {
  type = bool
  description = "Create a new repo"
}