# Local Development Environment

## Overview

This guide explains how to quickly set up a local development environment for Marble. This setup is optimized for fast testing and development, not for production use.

## Quick Start

1. **Clone the Repository**

   ```bash
   git clone git@github.com:checkmarble/marble.git
   cd marble
   ```

2. **Start the Environment**
   ```bash
   docker compose -f docker-compose-dev.yaml  --env-file .env.dev.example up
   ```
   > 💡 **Tip**: Create your own `.env.dev` file based on `.env.dev.example` for custom configuration.

3. **Log In**

   Once the `app` and `firebase_auth` containers are healthy, open [http://localhost:3000](http://localhost:3000). You will be redirected to the sign-in page.

   The Firebase Auth emulator is preconfigured with an admin user for the seeded `Zorg` organization:

   - Email: `jbe@zorg.com`
   - Password: `very-secret`

   This has been verified end-to-end: signing in against the emulator returns a Firebase ID token, exchanging it at the backend's `/token` endpoint returns a Marble access token with the `ADMIN` role for the seeded organization, and that token is accepted by the API.

## Included Components

The development environment includes everything needed to run Marble locally:

### Core Services

- Marble API (Backend)
- Marble Worker
- Marble Frontend

### Development Dependencies

- PostgreSQL database
- Redis cache
- Firebase Auth Emulator
- Elasticsearch instance
- yente (indexes sanctions data into Elasticsearch) and Motiva (screening API)
- Object storage emulation

## Configuration

### Basic Setup

The `.env.dev.example` provides a minimal configuration that works out of the box.

If you need to modify this configuration, note that the `.env` files are not inherited by the containers created by Docker Compose directly. Only select variables from the files are passed to the containers. If you need to add new variables (for example, if you want to configure file storage to point at your own S3 bucket), you will also need to edit the Docker Compose file to pass those variables to the appropriate container.

### Optional Features

You can enhance your development environment by configuring:

1. **Sanctions Screening**
   - Enable Motiva integration
   - Configure Elasticsearch

2. **Storage Features**
   - Set up local storage
   - Or connect to cloud storage

### Sanctions Screening Data

The `yente` container runs once at startup to index sanctions data into Elasticsearch, and Motiva then serves screening queries against that index.

By default, the dev stack indexes the reduced, **public** `us_sanctions` catalog defined in `contrib/datasets.yml`, which requires no credentials. That manifest is mounted into the container at `/app/manifests/default.yml`, and `docker-compose-dev.yaml` sets `YENTE_MANIFEST` to point at it.

> ⚠️ **Important**: yente defaults `YENTE_MANIFEST` to `/app/manifests/commercial.yml`, which pulls the full OpenSanctions database from `delivery.opensanctions.com` and requires a delivery token. If `YENTE_MANIFEST` is not set explicitly, the mounted dev manifest is silently ignored and indexing fails with an authentication error.

To index the full OpenSanctions database instead:

1. Sign up on the [OpenSanctions customer portal](https://www.opensanctions.org/) and copy the token from the *Data delivery service* section (see the [yente delivery docs](https://yente.followthemoney.tech/delivery/)).
2. In your env file, set `OPENSANCTIONS_DELIVERY_TOKEN` and switch `YENTE_MANIFEST` to `/app/manifests/commercial.yml`.

Delivery tokens are per-account secrets; there is no shared or public value, so never commit one to the repository.

### Ingesting Data via API

Before any data can be ingested, at least one table must exist in your organization's data model. In the app, this is done from the **Your Data** section in the sidebar (its **Data model** tab) by creating a table and adding fields; every table automatically gets the two required fields, `object_id` (string, unique per row) and `updated_at` (timestamp, used to reconcile successive versions of the same object).

Once a table exists, ingest data with your own script or tool by calling the versioned ingestion API:

1. Sign in to the app and generate an API key from **Settings > API Keys** (or `POST /apikeys` while authenticated with your session token). Treat this key as a secret local to your machine; never commit it.
2. Send batches of up to 100 objects per call to `POST /v1/ingest/{objectType}/batch`, authenticated with the `X-API-KEY` header. Each object must include `object_id` and `updated_at`, plus any other fields declared on the table; unknown fields are rejected.

```bash
curl -X POST "http://localhost:8080/v1/ingest/<table_name>/batch" \
  -H "X-API-KEY: <your_api_key>" \
  -H "Content-Type: application/json" \
  --data-binary @batch.json
```

See [Ingesting data](https://docs.checkmarble.com/docs/ingesting-data) for the full data model and validation rules (timestamp format, versioning behavior, etc).

## Troubleshooting

### Common Issues

1. **Port Conflicts**

   ```bash
   # Check for port usage
   lsof -i :8080
   lsof -i :3000
   ```

2. **Database Connection**
   - Ensure PostgreSQL is running
   - Check connection settings
   - Verify database exists

3. **Firebase Emulator**
   - Wait for complete startup
   - Check emulator logs
   - Verify port accessibility

4. **Sanctions indexing fails to authenticate**

   If the `yente` container exits with `Failed to authenticate to delivery.opensanctions.com with delivery token`, it is using the commercial manifest instead of the bundled dev one. Check that `YENTE_MANIFEST` is set on the `yente` service (it defaults to `/app/manifests/default.yml` in `docker-compose-dev.yaml`), or provide a delivery token as described in [Sanctions Screening Data](#sanctions-screening-data).

   ```bash
   docker compose -f docker-compose-dev.yaml --env-file .env.dev.example logs yente
   ```

   A healthy run ends with `Index update complete.` and the container exiting with code 0. Motiva only starts once yente has completed successfully.

5. **Sign-in page returns a 500 error**

   The frontend requires `SESSION_SECRET` to be at least 32 characters long. If it is too short, every request to `/sign-in` fails with `Password string too short (min 32 characters required)`. Generate a suitable value, replace `SESSION_SECRET` in your env file with it, then recreate the `app` container using that same file:

   ```bash
   openssl rand -base64 32
   # Copy the printed value into SESSION_SECRET in your env file (e.g. .env.dev.example or your own .env.dev), then:
   docker compose -f docker-compose-dev.yaml --env-file .env.dev.example up -d --force-recreate app
   ```

### Logs and Debugging

Access service logs:

```bash
# All services
docker compose logs -f

# Specific service
docker compose logs -f api
```

## Environment Variables

See the following files for configuration options:

- `.env.dev.example`: Development defaults
- `.env.example`: All available options
- `docker-compose.yaml`: Service configuration

## Next Steps

- [Production Deployment Guide](./production_run.md)
- [Deployment Architecture](./deployment.md)
- [Configuration Reference](./.env.example)

> ⚠️ **Remember**: This setup is for development only. See the [Production Deployment Guide](./production_run.md) for production setup.
