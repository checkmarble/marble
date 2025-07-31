# Marble GCP Deployment

Deploy Marble on Google Cloud Platform using Terraform with Cloud Run, Cloud SQL, and Firebase.

## Prerequisites

- Google Cloud account with billing enabled
- Terraform installed
- Domain name with SSL certificate
- Docker images access

## Quick Start

### 1. Setup
```bash
git clone https://github.com/checkmarble/marble.git
cd marble/terraform_templates/GCP
```

### 2. Configure
Edit `main.tf` with your GCS bucket for Terraform state:
```hcl
backend "gcs" {
  bucket = "your-bucket-for-tfstates"
}
```

### 3. Project Setup
Create a new GCP project or use existing one:
```bash
# Create new project (optional)
gcloud projects create your-project-id

# Set the project
gcloud config set project your-project-id
```

### 4. Environment
Edit `locals_environments.tf` with your configuration:
```hcl
production = {
  project_id = "your-project-id"
  terraform_service_account_key = "../service-account-key/project-id.json"

  frontend = {
    domain = "app.yourdomain.com"
    url    = "https://app.yourdomain.com"
  }

  backend = {
    domain = "api.yourdomain.com"
    url    = "https://api.yourdomain.com"
  }
}
```

### 5. Service Account
```bash
# Create service account key in Google Console
# Download as service-account-key/project-id.json
mkdir service-account-key
# Add your service account key file
```

**Service Account Setup:**
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Navigate to IAM & Admin → Service Accounts
3. Create a new service account with "Editor" role
4. Download the JSON key file
5. Save as `service-account-key/project-id.json`

### 6. Initialize APIs
```bash
cd service_init
terraform init
terraform workspace new production
terraform apply
cd ..
```

### 7. Deploy
```bash
terraform init
terraform workspace new production
terraform plan
terraform apply
```

### 8. Create Secrets
Create secret versions in Google Secret Manager:
- `postgres_password`: Database password (for postgres user)
- `cookie_session_secret`: Session secret (random string)
- `authentication_jwt_signing_key`: JWT signing key (RSA private key)

**Secret Creation:**
```bash
# Generate JWT signing key
openssl genrsa -out jwt-key.pem 2048

# Create secrets in Google Secret Manager
echo "your-db-password" | gcloud secrets create postgres_password --data-file=-
echo "your-session-secret" | gcloud secrets create cookie_session_secret --data-file=-
cat jwt-key.pem | gcloud secrets create authentication_jwt_signing_key --data-file=-
```

## Infrastructure

- **Cloud Run**: Serverless containers for frontend and backend
- **Cloud SQL**: PostgreSQL database with automated backups
- **Firebase**: Authentication and hosting
- **Cloud Storage**: File storage buckets
- **Secret Manager**: Secure secrets management
- **Load Balancer**: Global HTTPS load balancer

## Post-Deployment

### DNS Setup
```bash
terraform output --raw frontend_url
terraform output --raw backend_url
```
Create CNAME records for your domains pointing to the Cloud Run URLs:
- `app.yourdomain.com` → Frontend URL
- `api.yourdomain.com` → Backend URL

### Verify
```bash
gcloud run services list --platform managed
```

## Monitoring

- **Logs**: Cloud Logging with structured JSON
- **Health**: `/healthcheck` and `/liveness` endpoints

## Troubleshooting

```bash
# Check service status
gcloud run services describe marble-frontend --region=us-central1

# View logs
gcloud logging read "resource.type=cloud_run_revision" --limit=50

# Get service URLs
terraform output
```

## Support

- [Marble Documentation](https://docs.checkmarble.com/)
- [GitHub Issues](https://github.com/checkmarble/marble/issues)
- [Community Slack](https://join.slack.com/t/marble-communitysiege/shared_invite/zt-2b8iree6b-ZLwCiafKV9rR0O6FO7Jqcw)
