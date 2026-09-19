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
