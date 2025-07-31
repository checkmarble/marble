# Marble AWS Deployment

Deploy Marble on AWS using Terraform with ECS Fargate, RDS PostgreSQL, and Application Load Balancer.

## Prerequisites

- AWS account with CLI configured
- Terraform installed
- Domain name with SSL certificate
- Docker images access

## Quick Start

### 1. Setup
```bash
git clone https://github.com/checkmarble/marble.git
cd marble/terraform_templates/AWS
```

### 2. Configure
Edit `vars.tf` with your AWS profile and region:
```hcl
variable "aws_profile" { default = "your-profile" }
variable "aws_region" { default = "us-east-1" }
```

### 3. S3 Bucket
Create an S3 bucket for Terraform state:
```bash
aws s3 mb s3://your-terraform-state-bucket
aws s3api put-bucket-versioning --bucket your-terraform-state-bucket --versioning-configuration Status=Enabled
```

Edit `providers.tf` with your bucket name:
```hcl
backend "s3" {
  bucket = "your-terraform-state-bucket"
  key    = "marble/terraform.tfstate"
  region = "us-east-1"
}
```

### 4. Environment
```bash
cp locals_environments.tf.example locals_environments.prod.tf
```
Edit `locals_environments.prod.tf` with your configuration:

**Required Variables:**
- `aws_key_pair`: SSH RSA key pair name
- `aws_region`: AWS region (e.g., us-east-1)
- `aws_zones`: Availability zones (e.g., ["us-east-1a", "us-east-1b"])
- `domain`: Domain for SSL certificate

**Firebase Configuration:**
- Copy Firebase project parameters from your Firebase project settings
- Add to `locals.environments.production.firebase {}`

**Sentry Configuration:**
- Add Sentry DSN and environment settings

### 5. Credentials
```bash
mkdir config
```

**Firebase Service Account Key:**
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project → Project Settings → Service Accounts
3. Click "Generate new private key"
4. Save as `config/credentials.json`

**JWT Signing Key:**
```bash
openssl genrsa -out config/private.key 2048
```

### 6. Deploy
```bash
terraform init
terraform workspace new production
terraform plan
terraform apply
```

## Infrastructure

- **ECS Fargate**: 2 vCPU, 4GB RAM
- **ALB**: HTTPS with SSL termination
- **RDS**: PostgreSQL with automated backups
- **VPC**: Public subnets with security groups
- **CloudWatch**: Logging and monitoring

## Post-Deployment

### DNS Setup
```bash
terraform output --raw alb_url
```
Create CNAME records for your domains pointing to the ALB URL:
- `app.yourdomain.com` → ALB URL
- `api.yourdomain.com` → ALB URL

### Verify
```bash
aws ecs describe-services --cluster marble --services app
```

## Monitoring

- **Logs**: CloudWatch `/aws/ecs/marble`
- **Health**: `/healthcheck` and `/liveness` endpoints

## Troubleshooting

```bash
# Check service status
aws ecs describe-services --cluster marble --services app

# View logs
aws logs tail /aws/ecs/marble --follow

# Get ALB URL
terraform output --raw alb_url
```

## Support

- [Marble Documentation](https://docs.checkmarble.com/)
- [GitHub Issues](https://github.com/checkmarble/marble/issues)
- [Community Slack](https://join.slack.com/t/marble-communitysiege/shared_invite/zt-2b8iree6b-ZLwCiafKV9rR0O6FO7Jqcw)
