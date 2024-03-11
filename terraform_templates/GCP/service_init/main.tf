terraform {
  required_providers {
    google = {
      source  = "hashicorp/google-beta"
      version = "~>5.2"
    }
  }
  backend "gcs" {
    # TO CONFIGURE
    # name of the GCS bucket where the TF state is stored
    bucket = "my-bucket-for-tfstates"
    prefix = "service_init"
  }
}

provider "google" {
  credentials = file(local.environment.terraform_service_account_key)
  project     = local.project_id
  region      = local.location
}
