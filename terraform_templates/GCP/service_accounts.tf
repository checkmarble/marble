// backend service account
resource "google_service_account" "backend_service_account" {
  project      = local.project_id
  account_id   = "marble-backend-cloud-run"
  display_name = "Marble Backend Service Account"
}

# Allow backend service account to access any cloud sql instance
resource "google_project_iam_binding" "backend_service_account_cloudsql_client" {
  role    = "roles/cloudsql.client"
  project = local.project_id

  members = [
    google_service_account.backend_service_account.member
  ]
}

# Allow backend service account to invoke cloud run jobs
resource "google_project_iam_member" "backend_service_account_cron_run_invoker" {
  project = local.project_id
  role    = "roles/run.invoker"
  member  = google_service_account.backend_service_account.member
}



resource "google_service_account" "frontend_service_account" {
  account_id   = "marble-frontend-cloud-run"
  display_name = "Marble FrontEnd Service Account"
}
