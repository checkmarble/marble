# Terraform Templates

Community-contributed Terraform templates for deploying Marble on cloud platforms.

## Disclaimer

These templates are community contributions and come without guarantee and support. Successful deployment may require iterative tweaking as some steps require manual actions.

## Quick Start

Choose your cloud platform:

- **[AWS Deployment](AWS.md)** - Deploy on AWS with ECS Fargate, RDS, and ALB
- **[GCP Deployment](GCP.md)** - Deploy on GCP with Cloud Run, Cloud SQL, and Firebase

## Manual Steps Required

### GCP
- Create secret versions in Google Secret Manager after deployment
- Enable required APIs via service_init

### AWS
- Create S3 bucket for Terraform state
- Configure SSL certificates in AWS Certificate Manager
