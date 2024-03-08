
resource "google_project" "default" {
  project_id = local.project_id
  org_id     = 577386927588

  name = data.google_project.project.name

  labels = {
    "firebase" = "enabled"
  }
}

data "google_project" "project" {
  project_id = local.project_id
}

resource "google_project_service" "services" {
  for_each = toset([
    "cloudresourcemanager.googleapis.com",
    "storage.googleapis.com",        # to create cloud storage buckets
    "secretmanager.googleapis.com",  # to create secrets
    "sqladmin.googleapis.com",       # to create cloud sql instances
    "run.googleapis.com",            # to create cloud run services
    "iam.googleapis.com",            # to create service accounts
    "cloudscheduler.googleapis.com", # to create cloud scheduler jobs
    "firebase.googleapis.com",       # to create firebase projects
    "cloudidentity.googleapis.com",  # to create identity sources
  ])
  project = local.project_id
  service = each.key

  disable_on_destroy = false
}

# Enables Firebase services for the new project created above.
resource "google_firebase_project" "default" {
  project = local.project_id

  # Waits for the required APIs to be enabled.
  depends_on = [
    google_project_service.services
  ]
}
