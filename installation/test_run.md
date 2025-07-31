# Local Development Environment

## Overview

This guide explains how to quickly set up a local development environment for Marble. This setup is optimized for fast testing and development, not for production use.

## Quick Start

1. **Clone the Repository**

   ```bash
   git clone git@github.com:checkmarble/marble.git
   cd marble
   ```

2. **Configure Firebase Auth Emulator**

   The Firebase Auth emulator runs in a Docker container and needs to be accessible via the hostname `firebase-auth`. Add this entry to your `/etc/hosts` file:

   ```bash
   # Add this line to /etc/hosts (requires sudo/admin privileges)
   echo "127.0.0.1 firebase-auth" | sudo tee -a /etc/hosts
   ```

   > ⚠️ **Important**: This step is required for the Firebase Auth emulator to work properly. Without this, authentication will fail.

3. **Start the Environment**
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
- Firebase Auth Emulator
- Elasticsearch instance
- Object storage emulation

## Configuration

### Basic Setup

The `.env.dev.example` provides a minimal configuration that works out of the box.

If you need to modify this configuration, note that the `.env` files are not inherited by the containers created by Docker Compose directly. Only select variables from the files are passed to the containers. If you need to add new variables (for example, if you want to configure file storage to point at your own S3 bucket), you will also need to edit the Docker Compose file to pass those variables to the appropriate container.

### Optional Features

You can enhance your development environment by configuring:

1. **Webhooks Testing**

   - Configure Convoy settings
   - See [Production Deployment Guide](./production_run.md)
   - Set webhook endpoints

2. **Sanctions Screening**

   - Enable Yente integration
   - Configure Elasticsearch

3. **Storage Features**
   - Set up local storage
   - Or connect to cloud storage

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
   - Ensure `firebase-auth` is added to `/etc/hosts` (see step 2 above)
   - Check that `127.0.0.1 firebase-auth` resolves correctly:
     ```bash
     ping firebase-auth
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
