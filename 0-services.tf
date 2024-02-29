resource "google_project_service" "gsp-service" {
  count = length(var.apis)
  project = var.project
  service = var.apis[count.index]
}