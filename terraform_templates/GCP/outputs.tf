output "frontend_domain" {
  value = local.environment.frontend.domain
}
output "frontend_cloudrun_uri" {
  value = google_cloud_run_v2_service.frontend.uri
}

output "backend_uri" {
  value = google_cloud_run_v2_service.backend.uri
}
