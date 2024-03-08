terraform {
  required_providers {
    google = {
      source  = "hashicorp/google-beta"
      version = "~>5.2"
    }
  }
  backend "gcs" {
    # name of the GCS bucket where the TF state is stored
    bucket = "backend_bucket_name"
    prefix = "environment"
  }
}

provider "google" {
  credentials = file(local.environment.terraform_service_account_key)
  project     = local.project_id
  region      = local.location
}
