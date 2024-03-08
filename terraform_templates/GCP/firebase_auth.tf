resource "google_identity_platform_config" "auth" {
  project = local.project_id

  sign_in {
    allow_duplicate_emails = false

    anonymous {
      enabled = false
    }

    email {
      enabled           = true
      password_required = true
    }
  }

  authorized_domains = compact([
    data.google_firebase_web_app_config.frontend.auth_domain,
    local.environment.frontend.domain,
    local.environment.backoffice.domain,
    trimprefix(google_cloud_run_v2_service.frontend.uri, "https://"),
  ])
}
