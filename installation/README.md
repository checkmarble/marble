# Marble Installation Guide

## Overview

Welcome to Marble! This guide will help you get started with installing and deploying Marble. Choose the path that best matches your needs:

- 🚀 [Quick Start](#quick-start) - Get up and running quickly
- 💻 [Local Development](./test_run.md) - Set up a development environment
- 🌐 [Production Deployment](./production_run.md) - Deploy for production use
- 🏗️ [Architecture Overview](#architecture-overview) - Understand Marble's components

## Quick Start

### Prerequisites

- Docker and Docker Compose
- Git
- 4GB RAM minimum
- 10GB disk space

### Basic Installation

```bash
# 1. Clone the repository
git clone <repository-url>
cd marble

# 2. Copy example environment file
cp .env.dev.example .env.dev

# 3. Start Marble
docker compose -f docker-compose-dev.yaml --env-file .env.dev.example up
```

## Architecture Overview

### Core Components

Marble consists of three main services:

1. **Backend API** (Go + Gin)

   - REST API server
   - Business logic
   - Database interactions

2. **Worker** (Go)

   - Background tasks
   - Scheduled jobs
   - Data processing

3. **Frontend** (TypeScript + Remix)
   - Web interface
   - User interactions
   - API integration

In addition, Marble relies on a few supporting services:

- **PostgreSQL** (v16+) — primary datastore and job queue
- **Redis** — cache used by the backend and worker. Currently optional but increasingly required as more features depend on it; we recommend configuring it. See [Production Deployment](./production_run.md#6-redis) for details.
- **Elasticsearch + Motiva** — only needed for sanctions screening
- **Blob storage** (GCS / S3 / Azure) and a **Firebase project** for authentication

### System Architecture

At a high level, a marble deployment is structured like this 
![Deployment Architecture](https://github.com/user-attachments/assets/527e414b-e58c-478b-a156-a2142ab494cf)

And at a higher level of granularity:
![Deployment Architecture](https://github.com/user-attachments/assets/f2b1fe74-d083-4f1e-860c-c8a7169770ad)

## Deployment Options

### 1. Local Development

Best for:

- Testing features
- Quick evaluation
  → [Local Setup Guide](./test_run.md)

### 2. Production Server

Best for:

- Production deployments
- Custom infrastructure
- Self-hosted installations
  → [Production Guide](./production_run.md)

### 3. Cloud Deployment

Best for:

- Scalable deployments
- Managed services
- Cloud-native architecture
  → [Production Guide](./production_run.md)

## Configuration

### Environment Files

**Simple template for local run**

- `.env.dev.example` - Development configuration template
- `docker-compose-dev.yaml` - Development container setup

**Complete template for production run**

- `.env.example` - Production configuration template
- `docker-compose.yaml` - Container orchestration

## Version Management

### Release schedule

A new version of the Marble application is released about every week, usuallly in the beginning of the week.

Every release on the [Marble repository](https://github.com/checkmarble/marble) consists in a pair of versions for the backend and frontend containers. For example, version 0.36.0 of Marble uses the backend container v0.36.1 and frontend container v0.36.1. Refer to the versions used in the `docker-compose.yaml` file to know which versions to run together in a given release.

Most new features are released as minor versions (according to semantic versioning), while releases that only contain bug fixes or dependency upgrades may be released as patch versions.

If the release makes important changes to the Marble interface, the configuration options, or the API, this is emphasized in the release note attached to the release.

We recommend you update your Marble version at least every few weeks.

### Upgrading Marble

1. Check out new version
2. Run migrations:

   ```bash
   # Option 1: Restart backend container
   docker compose restart api

   # Option 2: Run migration only
   docker compose run --rm api --migrate
   ```

   The database migrations are designed such that you can safely run the migration for version N+1 while still serving version N, and upgrade the backend and frontend containers after the migration is done. Some migrations may take a while to run, if new indexes need to be created or if some existing data needs to be migrated to a new format. Most migrations are expected to run very quickly.

   The same migration SHOULD NOT be run in several processes/containers in parallel.

3. Upgrade the backend and frontend containers:

   ```bash
   # Stop all containers
   docker compose down

   # Start with new versions
   docker compose -f docker-compose.yaml --env-file ./env up -d
   ```

4. Best practices:

   - Test in staging first
   - Schedule during low traffic

### Version Support

- Latest version: Check releases page
- Support policy: We only support the latest version. You should upgrade regularly to stay on a supported version.
- Marble app versions guide: see [versions documentation](./versions.md)
- Migration path: You must upgrade versions one at a time in sequence (e.g. v0.35 -> v0.36 -> v0.37). Skipping versions is not recommended.

## Getting Help

- 📖 [Product Documentation](https://docs.checkmarble.com/)
- 🔧 [Troubleshooting Guides](./test_run.md#troubleshooting)
- 📋 [Issue tracker](https://github.com/checkmarble/marble/issues)
- 💬 [Community support](https://join.slack.com/t/marble-communitysiege/shared_invite/zt-2b8iree6b-ZLwCiafKV9rR0O6FO7Jqcw)

## Additional Resources

- [Environment Variables Guide](../.env.example)
- [Docker Configuration](../docker-compose.yaml)
- [Version support policy](./version_support_policy.md)
- [Create a first organization and user](./first_connection.md)

---

> 💡 **Tip**: Start with the [Local Development Guide](./test_run.md) to get familiar with Marble before moving to production.
