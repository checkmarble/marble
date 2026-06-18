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

- Production-grade PostgreSQL database (v16+)
- Blob storage bucket (GCS, S3...)
- Firebase project
- Redis instance (recommended — see [Redis](#6-redis) below)
- Motiva+Elasticsearch setup if you need sanction checks
- We do not recommend usage of docker compose for a production-ready deployment of Marble

## Detailed Dependencies Setup

### 1. PostgreSQL Database

Requirements:

- Version: 16 or higher
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
- Offload detailed data on rule execution from the main database, which would otherwise use up a lot of storage volume for nothing
- Parquet data storage for analytics queries

Supported Providers:

- Google Cloud Storage
- Amazon S3
- Azure Blob Storage
- Any S3-compatible storage, such as Minio

Configuration details are available in `.env.example`.
The .env file expects two different buckets for the two purposes, but you may use the same bucket for both.

> ⚠️ **Note**: We strongly suggest you configure data offloading to run in production. See [data offloading](./data_offloading.md)

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
   - Go to Project overview → project settings → Service Accounts → Generate new private key (or if you are using GCP to deploy Marble, create a service account with the relevant permissions, and give it specifically the permission to list and edit Firebase Auth users)
   - Optionally (but preferably), use the [Marble password reset email](../contrib/firebase_email_reset_mail.html) as a custom template for Firebase auth password reset (Adjust the app URL !). This can be configured at https://console.firebase.google.com/u/0/project/{projectId}/authentication/emails under the "password reset" section.

3. **Configure Domain**
   - Go to Authentication → Settings → Authorized Domains
   - Add your Marble application domain (should use https)

4. **Add an app to your project**
   - From your project homepage, go to Add app → Web
   - Choose a name and click on Register app
   - In the Firebase SDK section, keep "Use npm" ticked and click on Continue to console

5. **Optional: Configure sign-in with Google/Microsoft**
   - [Google Sign-in](https://firebase.google.com/docs/auth/web/google-signin)
   - [Microsoft Sign-in](https://firebase.google.com/docs/auth/web/microsoft-oauth)

6. **Environment Setup**

   #### Backend
   - Mount service account key in backend container (see volumes on the api container in `docker-compose.yaml`)
   - Set GOOGLE_APPLICATION_CREDENTIALS path

   #### Frontend
   - Configure Firebase variables (see `.env.example`)

   You can find you **FIREBASE_API_KEY** from Project settings → General → Web API Key

7. **Optional: Custom onboarding email**
   - You can set up a custom onboarding email that will be sent when you add a user to your Marble instance, as described in [Firebase onboarding email](./firebase_onboarding_email.md)

> 💡 **Cost**: Firebase Auth free tier should be sufficient, but credit card required for project setup.

### 5. Motiva + Elasticsearch

Purpose: Sanctions screening and search functionality

Options:

- Self-hosted Motiva + Yente (indexer) + Elasticsearch
- OpenSanctions managed API

> ⚠️ **Note**: While development docker-compose includes Elasticsearch, use a production-grade service for deployment.

You will need to run indexing on the yente (with `yente reindex`) on a scheduled task (cron or systemd timer).

### 6. Redis

Purpose: Cache used by the Marble backend and worker (for example, to cache the data model and user lookups).

Redis is currently **optional but increasingly required** as more features come to depend on it, so we recommend provisioning it for any new deployment.

Behaviour:

- If `REDIS_HOST` is left empty, the cache is disabled and Marble runs without it.
- If `REDIS_HOST` is set, Marble checks connectivity to Redis on startup and **will fail to start if it cannot reach it**. Make sure both the `api` and `worker` containers can reach the instance.

Configuration:

- `REDIS_HOST`: host and port of the Redis instance (e.g. `redis:6379`)
- `REDIS_KEY`: password/auth key, if your instance requires authentication
- `REDIS_TLS`: set to `true` to connect over TLS
- `REDIS_TLS_SKIP_VERIFY`: set to `true` to skip TLS certificate verification (not recommended)

> ⚠️ **Note**: The provided `docker-compose.yaml` includes a Redis container and sets `REDIS_HOST` automatically for the sake of completeness. For production, use a managed/production-grade Redis instead (e.g. GCP Memorystore, AWS ElastiCache).

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

You will find a complete guide of environment variables to pass to the Marble app in [our documentation](https://docs.checkmarble.com/docs/technical-configuration#/).

Alternatively, you can also inspire yourself from the docker compose example:

- `.env.example`: Environment variables
- `docker-compose.yaml`: Service configuration

## Troubleshooting

### Common Issues

1. **API URL Configuration**

- Frontend needs one API URL configured:
  - `MARBLE_API_URL`: URL for container-to-container requests
    - Example: `http://api:8080` (Docker internal network)

- Incorrect configuration leads to:
  - Missing variable means the frontend container will not start
  - Wrong value, or unreachable network, means the container will start but fail immediately as soon as you try to access the page

2. **Network Connectivity**
   - Confirm services can reach each other
   - Check firewall rules
   - Verify DNS resolution works
   - Test internal container networking

3. **Invalid Google Cloud Service Account**

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

4. **Firebase Configuration**

- Service account:
  - Check that the detected Google Cloud project and service account match your environment

- Required environment variables (on the backend container):
  - `FIREBASE_API_KEY`: Web API key from Firebase Console

- If you plan on using Single-Sign On (SSO) with Firebase (to delegate authentication to another Identity Provider), you will need to configure the following directives:
  - `FIREBASE_AUTH_DOMAIN`: Auth domain from Firebase settings

## Next Steps

- [Deployment Architecture](./README.md#system-architecture)
- [Version Upgrade Guide](./README.md#version-management)

5. **Sign-in fields inactive**

The app's sign-in fields may be inactive without further error if the app fails to hydrate on the browser side. Because Marble uses server-side rendering, such errors may happen if you inject additional js files (for example using Cloudflare's rocket loader) in a layer "between" the server-side render and the browser-side render.
