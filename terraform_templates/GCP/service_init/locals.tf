locals {
  location    = "europe-west1"
  environment = local.environments[terraform.workspace]
  # shortcut
  project_id = local.environments[terraform.workspace].project_id
}
