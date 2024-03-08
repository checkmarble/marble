locals {

  environments = {

    production = {
      project_id                    = "marble-prod-1"
      terraform_service_account_key = "../service-account-key/marble-prod-1.json"

      marble_cloud_sql = {
        name              = "marble-prod"
        location          = local.location
        tier              = "db-custom-4-16384"
        availability_type = "REGIONAL"
      }

      firebase = {
        frontend_app_id = "app_id"
      }

      env_display_name = "production"

      segment_write_key = {
        frontend = "bEDdodQ5CBrUFeaHvVClSf0BfuWYyzeN"
        backend  = "JeAT8VCKjBs7gVrFY23PG7aSMPqcvNFE"
      }

      frontend = {
        image  = "europe-west1-docker.pkg.dev/marble-infra/marble/marble-frontend:v0.0.25"
        domain = "app.mydomain.com"
        url    = "https://app.mydomain.com"
      }

      backend = {
        image              = "europe-west1-docker.pkg.dev/marble-infra/marble/marble-backend:v0.0.43"
        domain             = "api.mydomain.com"
        url                = "https://api.mydomain.com"
        max_instance_count = 10
      }
    }

  }
}
