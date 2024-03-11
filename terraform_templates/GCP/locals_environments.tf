locals {

  environments = {

    production = {
      # TO CONFIGURE
      project_id                    = "project-id"
      terraform_service_account_key = "../service-account-key/project-id.json"

      marble_cloud_sql = {
        name              = "marble-db"
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
        image  = "europe-west1-docker.pkg.dev/marble-infra/marble/marble-frontend:latest"
        domain = "app.mydomain.com"
        url    = "https://app.mydomain.com"
      }

      backend = {
        image              = "europe-west1-docker.pkg.dev/marble-infra/marble/marble-backend:latest"
        domain             = "api.mydomain.com"
        url                = "https://api.mydomain.com"
        max_instance_count = 10
      }
    }

  }
}
