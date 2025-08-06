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

### 3. Firebase Authentication

#### Setup Steps

1. **Create Firebase Project**

   - Visit [Firebase Console](https://console.firebase.google.com/)
   - Create a new project or use an existing GCP project

2. **Configure Authentication**

   - Enable Firebase Authentication
   - Go to Project overview → project settings → Service Accounts → Generate new private key (or if you are using GCP to deploy Marble, create a service account with the relevant permissions, and give it specifically the permission to list and edit Firebase Auth users)
   - Optionally (but preferably), use the [Marble password reset email](../contrib/firebase_email_reset_mail.html) as a custom template for Firebase auth password reset (Adjust the app URL !). This can be configured at https://console.firebase.google.com/u/0/project/{projectId}/authentication/emails under the "password reset" section.

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

### 4. Convoy (Webhook Gateway)

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

### 5. Yente + Elasticsearch

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

   - Frontend needs two API URLs configured:
     - `MARBLE_API_URL_CLIENT`: URL for browser requests (public URL)
       - Example: `https://api.yourdomain.com`
     - `MARBLE_API_URL_SERVER`: URL for container-to-container requests
       - Example: `http://api:8080` (Docker internal network)
   - Incorrect configuration leads to:
     - Failed API calls
     - CORS errors
     - Authentication failures

3. **Network Connectivity**

   - Confirm services can reach each other
   - Check firewall rules
   - Verify DNS resolution works
   - Test internal container networking

4. **Firebase Configuration**

   - Service Account Key:

     - ⚠️ Backend service will fail to start without accessible Firebase service account key
     - Exception: On GCP, automatic service account discovery may work
     - Generate key in Firebase Console → Project Settings → Service Accounts
     - Mount key file to container and set `GOOGLE_APPLICATION_CREDENTIALS`
     - Example: `GOOGLE_APPLICATION_CREDENTIALS=/secrets/firebase-key.json`

   - Required Environment Variables:
     - `GOOGLE_CLOUD_PROJECT`: Firebase project ID
     - `FIREBASE_API_KEY`: Web API key from Firebase Console
     - `FIREBASE_AUTH_DOMAIN`: Auth domain from Firebase settings
     - `FIREBASE_APP_ID`: Application ID from Firebase Console

## Next Steps

- [Deployment Architecture](./README.md#system-architecture)
- [Version Upgrade Guide](./README.md#version-management)
