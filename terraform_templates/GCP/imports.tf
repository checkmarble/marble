import {
  id = "projects/${local.project_id}/locations/${local.location}/services/marble-backend"
  to = google_cloud_run_v2_service.backend
}

import {
  id = "projects/${local.project_id}/locations/${local.location}/services/marble-frontend"
  to = google_cloud_run_v2_service.frontend
}
