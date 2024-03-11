locals {

  environments = {

    production = {
      # TO CONFIGURE
      project_id                    = "project-id"
      terraform_service_account_key = "../../service-account-key/project-id.json"

      firebase = {
        frontend_app_id = "app_id"
      }

      env_display_name = "production"
    }

  }
}
