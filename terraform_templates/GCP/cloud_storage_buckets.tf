
resource "google_storage_bucket" "case_manager" {
  name                     = "case-manager-${local.project_id}"
  location                 = local.location
  force_destroy            = true
  public_access_prevention = "enforced"

  uniform_bucket_level_access = true
}

resource "google_storage_bucket_iam_member" "backend_service_account_case_manager_object_admin" {
  bucket = google_storage_bucket.case_manager.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.backend_service_account.email}"
}

resource "google_storage_bucket_iam_member" "backend_service_account_case_manager_bucket_reader" {
  bucket = google_storage_bucket.case_manager.name
  role   = "roles/storage.legacyBucketReader"
  member = "serviceAccount:${google_service_account.backend_service_account.email}"
}




resource "google_storage_bucket" "data_ingestion" {
  name                     = "data-ingestion-${local.project_id}"
  location                 = local.location
  force_destroy            = true
  public_access_prevention = "enforced"

  uniform_bucket_level_access = true
}

resource "google_storage_bucket_iam_member" "backend_service_account_object_admin" {
  bucket = google_storage_bucket.data_ingestion.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.backend_service_account.email}"
}

resource "google_storage_bucket_iam_member" "backend_service_account_bucket_reader" {
  bucket = google_storage_bucket.data_ingestion.name
  role   = "roles/storage.legacyBucketReader"
  member = "serviceAccount:${google_service_account.backend_service_account.email}"
}
