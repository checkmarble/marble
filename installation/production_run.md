# Production Deployment Guide

## Overview

This guide explains how to deploy Marble in a production environment. It covers all required dependencies, configuration steps, and deployment options.

## Prerequisites

Before starting a production deployment, ensure you have:

### Required Expertise

- Docker containerization
- DNS configuration and TLS certificates
- PostgreSQL database administration
- Cloud provider experience (GCP/AWS/Azure/other)

### Required Infrastructure

- Production-grade PostgreSQL database (v15+)
- Blob storage bucket (GCS, S3...)
- Firebase project
- Convoy instance if you need webhooks
- Yente+Elasticsearch setup if you need sanction checks

## Detailed Dependencies Setup

### 1. PostgreSQL Database

Requirements:

- Version: 15 or higher
- Database name: `marble`
- Schema: `marble,public`

#### Configuration

```sql
-- If not using default postgres user:
CREATE SCHEMA IF NOT EXISTS marble;
ALTER USER your_user SET search_path TO marble,public;
GRANT ALL ON SCHEMA marble TO your_user;
```

> ⚠️ **Note**: While the development docker-compose includes PostgreSQL, do not use this for production. Use a managed service like GCP Cloud SQL or AWS RDS instead.

> 🚫 **Unsupported**: Marble has not been tested with PostgreSQL-compatible databases (CockroachDB, AlloyDB...).

### 2. Cloud Storage

Purpose:

- Store CSV files for batch ingestion
- Store documents for case management

Supported Providers:

- Google Cloud Storage
- Amazon S3
- Azure Blob Storage
- Any S3-compatible storage, such as Minio

Configuration details are available in `.env.example`.
The .env file expects two different buckets for the two purposes, but you may use the same bucket for both.

### 3. Google Cloud service account

Marble requires valid service account credentials in order to provide the following features:

 - Authentication via Firebase (mandatory)
 - Blob storage on Google Cloud Storage (if applicable)

This service account **must** have the following roles or permissions:

 - Role: `Storage Object User` on the configured buckets to store and retrieve blobs
 - Permission: `iam.serviceAccounts.signBlob` to generate pre-signed download URLs
   This permission is provided by the `Service Account Token Creator` role, but we recommend creating a custom role containing the required permission only.

_Note:_ depending on whether you are hosted on GCP, the service account might need extra permissions to accomodate your setup.

#### Provide the credentials to Marble

Marble supports two ways to retrieve the service account's credentials:

 - **Recommended:** Marble is able to retrieve the service account (and associated configuration) from the [Application Default Credentials (ADC)](https://cloud.google.com/docs/authentication/application-default-credentials). If you have properly configured the system on which Marble runs, it should be able to automatically use the configured service account. \
   If Marble is running on Google Cloud Platform, the service account is pulled from the environment, depending on how you configured your infrastructure.
 - Alternatively, you can download a file-based service account key and provide the path to it in the `GOOGLE_APPLICATION_CREDENTIALS` environment variable.

By default, it will be assumed that the service account's Google Cloud project is the project where your Firebase tenant lives. If that is the case, no further configuration is required. If, on the other hand, your Firebase project and Google Cloud project are separate, you will need to specify the name of your Firebase project in the `FIREBASE_PROJECT_ID` environment variable.

### 4. Firebase Authentication

#### Setup Steps

1. **Create Firebase Project**

   - Visit [Firebase Console](https://console.firebase.google.com/)
   - Create a new project or use an existing GCP project

2. **Configure Authentication**

   - Enable Firebase Authentication

3. **Configure Domain**

   - Go to Authentication → Settings → Authorized Domains
   - Add your Marble application domain (should use https)

4. **Optional: Configure sign-in with Google/Microsoft**

   - [Google Sign-in](https://firebase.google.com/docs/auth/web/google-signin)
   - [Microsoft Sign-in](https://firebase.google.com/docs/auth/web/microsoft-oauth)

5. **Environment Setup**

   #### Backend

   - Mount service account key in backend container (see volumes on the api container in `docker-compose.yaml`)
   - Set GOOGLE_APPLICATION_CREDENTIALS path

   #### Frontend

   - Configure Firebase variables (see `.env.example`)

> 💡 **Cost**: Firebase Auth free tier should be sufficient, but credit card required for project setup.

### 5. Convoy (Webhook Gateway)

Options:

- Self-hosted: Follow [Docker installation guide](https://www.getconvoy.io/docs/deployment/install-convoy/docker)
- Managed: Use [Convoy Cloud](https://www.getconvoy.io/)

Setup Steps:

1. Create webhooks project
2. Generate API key
3. Configure in Marble:
   ```bash
   CONVOY_API_URL=https://your-convoy-instance/api
   CONVOY_API_KEY=your-api-key
   CONVOY_PROJECT_ID=your-project-id
   ```

### 6. Yente + Elasticsearch

Purpose: Sanctions screening and search functionality

Options:

- Self-hosted Yente + Elasticsearch
- OpenSanctions managed API

> ⚠️ **Note**: While development docker-compose includes Elasticsearch, use a production-grade service for deployment.

It is recommended to deploy the Yente API with multiple workers (see the `docker-compose.yaml` to see how) and disable the indexing process on those with `YENTE_AUTO_REINDEX=false`) so it doesn't impact production workloads and is not duplicated across workers.

Once automatic background indexing is disabled, you will need to run it (with `yente reindex`) separately through a different container or a scheduled task (cron or systemd timer).

## Deployment Architecture

### Components

The Marble platform consists of three services:

1. **Marble API**

   - Main backend service
   - Handles REST API requests
   - Requires direct database access

2. **Marble Worker**

   - Background task processor
   - Uses same container as API
   - Handles scheduled jobs & tasks

3. **Marble Frontend**
   - User interface
   - Browser application
   - Communicates with API

### Deployment Options

1. **Server/VM Deployment**

   - Use nginx/reverse proxy
   - Route requests to services
   - Manage SSL termination

2. **Managed Container Service**

   - GCP Cloud Run
   - AWS ECS
   - Or similar option at other cloud providers
   - Configure auto-scaling

3. **Kubernetes**
   - Deploy as containers
   - Use service mesh
   - Configure ingress

## App Configuration

Reference the following files for detailed configuration:

- `.env.example`: Environment variables
- `docker-compose.yaml`: Service configuration

## Troubleshooting

### Common Issues

1. **CORS Errors**

   - Ensure `MARBLE_APP_URL` environment variable is set correctly
   - Must use `https://` protocol in production
   - Example: `MARBLE_APP_URL=https://app.yourdomain.com`
   - Common symptoms:
     - API requests failing in browser
     - Console errors about CORS policy
     - Authentication issues

2. **API URL Configuration**

   - Frontend needs one API URLs configured:
     - `MARBLE_API_URL_SERVER`: URL for container-to-container requests
       - Example: `http://api:8080` (Docker internal network)
     - `MARBLE_API_URL_CLIENT`: URL for browser requests (public URL)
       - Example: `https://api.yourdomain.com`


   - Incorrect configuration leads to:
     - Failed API calls
     - CORS errors
     - Authentication failures

3. **Network Connectivity**

   - Confirm services can reach each other
   - Check firewall rules
   - Verify DNS resolution works
   - Test internal container networking

4. **Invalid Google Cloud Service Account**

Check Marble's startup logs for messages related to Google Cloud Platform's authentication, they may be able to point your to a potential misconfiguration:

For example, a good configuration would look like this:

```
2025-05-27T14:12:41+02:00 INFO successfully authenticated in GCP principal=marble-dev@my-projectiam.gserviceaccount.com project=my-project
2025-05-27T14:12:41+02:00 INFO FIREBASE_PROJECT_ID was not provided, falling back to Google Cloud project project=my-project
2025-05-27T14:12:41+02:00 INFO firebase project configured project=my-project
```

Those lines indicate:

 - The authenticated service account is `marble-dev@my-project.iam.gserviceaccount.com project=my-project`
 - The detected Google Cloud Project is `my-project`
 - The assumed Firebase project is also `my-project`

You can verify that those value match your environment if you encounter any issue.

5. **Firebase Configuration**

  - Service account:
    - Check that the detected Google Cloud project and service account match your environment

  - Required environment variables:
    - `FIREBASE_API_KEY`: Web API key from Firebase Console

  - If you plan on using Single-Sign On (SSO) with Firebase (to delegate authentication to another Identity Provider), you will need to configure the following directives:
    - `FIREBASE_AUTH_DOMAIN`: Auth domain from Firebase settings

## Next Steps

- [Deployment Architecture](./README.md#system-architecture)
- [Version Upgrade Guide](./README.md#version-management)
