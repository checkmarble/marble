# Bare-metal deployment

> [!WARNING]
> This page is an adaptation of the production installation documentation without the use of Docker. Most instructions from that page are still relevant here. Notably, baremetal deployment requires the same set of environment variable as any other.

## Requirements

- An Ubuntu 24.10 system (this guide will assume you wish to deploy Marble on a single machine, feel free to adapt configuration if you deploy on several).
- PostgreSQL database (≥ 15.0).
- NodeJS
- Golang
- Blob storage platform (S3, GCS, Azure Blob or S3-compatible self-hosted)

> [!NOTE]
> This guide was crafted using the indicated Linux distribution. Marble should work properly on any distribution, providing the dependencies can be obtained. Specific instructions for other systems are outside the scope of this guide.

```bash
# apt update
# apt install git golang nodejs npm
# npm install -g pnpm
```

> [!NOTE]
> In the future, Marble will provide pre-built binaries and artifacts, but until then, all components must be built from source.

### Pull the sources

```bash
# mkdir -p /opt/marble/{api,front,src} /etc/marble && chmod 755 /etc/marble
# install -m 740 /dev/null /etc/marble/api.conf && install -m 740 /dev/null /etc/marble/front.conf
# cd /opt/marble/src
# git clone https://github.com/checkmarble/marble && cd marble
# git checkout v0.32.0
# git config submodule.api.url https://github.com/checkmarble/marble-backend.git
# git config submodule.front.url https://github.com/checkmarble/marble-frontend.git
# git submodule update --init
```

### Create a user

```bash
# useradd -rd /opt/marble -s /usr/sbin/nologin marble
```

## Backend

```bash
# cd /opt/marble/src/marble/api
# go build -o /opt/marble/api/ .
# chown -R marble: /opt/marble/api
```

### Configuration

Add the Firebase service account JSON key into the configuration directory and give it the proper permission (the `marble` user must be able to read it):

```bash
# mv /path/to/firebase.json /etc/marble/firebase.json
# chown root:marble /etc/marble/firebase.json && chmod 740 /etc/marble/firebase.json
```

Generate a 4096-bit RSA private key to be used as a signing secret for session tokens:

```bash
# openssl genrsa -out /etc/marble/jwtsigningkey.key
# chown root:marble /etc/marble/jwtsigningkey.key && chmod 740 /etc/marble/jwtsigningkey.key
```

Copy the [example configuration](https://github.com/checkmarble/marble-backend/blob/main/.env.example) file into `/etc/marble/api.conf`and edit the relevant settings. Among others:

- Set the `PG_*` variables to point to your PostgresSQL instance.
- Set the `GOOGLE_CLOUD_PROJECT` to the ID of your Firebase project.
- The `GOOGLE_APPLICATION_CREDENTIALS` should contain the path to the JSON private key file downloaded from Firebase.
- Set `AUTHENTICATION_JWT_SIGNING_KEY_FILE` to point to the generated RSA private key at `/etc/marble/jwtsigningkey.pem`.
- `*_BUCKET_URL`should point to buckets in your blob storage platform (S3, Azure Blob or GCS).
If you are using Minio, use a URL such as `s3://<bucket>?awssdk=v1&endpoint=minio.domain.com&region=us-east-1&s3ForcePathStyle=true`. In this case, you may also add `disableSSL=true` if your MinIO instance is in cleartext.
You might have to add provider-specific configuration, for example for authentication (for S3 and MinIO, for example, set `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`.
- Set the `CREATE_*` variables to specify your initial organization and admin user.
- Set your `LICENCE_KEY`.
- Set `MARBLE_APP_URL` to the URL used to access the frontend.

### Service configuration

Marble’s backend is composed of five discrete services, three of which are scheduled tasks. Those can be configured with the following systemd units:

#### API *(persistent service)*

```bash
# /etc/systemd/system/marble-api.service
[Unit]
Description=Marble backend API

[Service]
Type=simple
Restart=always
EnvironmentFile=/etc/marble/api.conf
WorkingDirectory=/opt/marble/api
User=marble
Group=marble
ExecStart=/opt/marble/api/marble-backend -server

[Install]
WantedBy=multi-user.target
```

#### Worker *(persistent service)*

```bash
# /etc/systemd/system/marble-worker.service
[Unit]
Description=Marble backend worker

[Service]
Type=simple
Restart=always
EnvironmentFile=/etc/marble/api.conf
WorkingDirectory=/opt/marble/api
User=marble
Group=marble
ExecStart=/opt/marble/api/marble-backend -worker

[Install]
WantedBy=multi-user.target
```

#### Database migrator *(manual run only)*

```bash
# /etc/systemd/system/marble-migrate.service
[Unit]
Description=Marble backend DB migration

[Service]
Type=oneshot
EnvironmentFile=/etc/marble/api.conf
WorkingDirectory=/opt/marble/api
User=marble
Group=marble
ExecStart=/opt/marble/api/marble-backend -migrations
```

Once the unit files are created, you can enable and start all of them with the following commands:

```bash
# systemctl daemon-reload
# systemctl start marble-migrate
# systemctl enable --now marble-api marble-worker
```

### Check that the API is running

```bash
$  curl http://127.0.0.1:8080/liveness
{"mood":"Feu flammes !"}
```

## Frontend

```bash
# cd /opt/marble/src/marble/front
# pnpm install --frozen-lockfile
# pnpm --filter=app-builder run build
# pnpm --filter=app-builder --prod deploy /opt/marble/front/
# cp -a packages/app-builder/build /opt/marble/front/
# chown -R marble: /opt/marble/front
```

### Configuration

Copy the [example configuration](https://github.com/checkmarble/marble-frontend/blob/main/packages/app-builder/.env.example) file into `/etc/marble/front.conf`and edit the relevant settings. Among others:

- `NODE_ENV` must be set to `production`.
- `ENV` should be set to `production`.
Note that this will require setting up TLS certificates to access the frontend. If prototyping without TLS, set this to `development`.
- Set a random, high-entropy `SESSION_SECRET`.
- `MARBLE_API_URL_SERVER` should be the external HTTP base your users’ browsers can use to reach the API.
- `MARBLE_APP_URL` should be set to the external HTTP base your users’ browsers can use to reach the frontend.
- Set the different Firebase configuration settings with the information retrieved from your Firebase account.

### Service configuration

Drop this `systemd`unit file in ``/etc/systemd/system/marble-front.service``:

#### Frontend

```bash
# /etc/systemd/system/marble-front.service
[Unit]
Description=Marble frontend

[Service]
Type=simple
Restart=always
EnvironmentFile=/etc/marble/front.conf
WorkingDirectory=/opt/marble/front
User=marble
Group=marble
ExecStart=/opt/marble/front/node_modules/@remix-run/serve/dist/cli.js ./build/server/index.js

[Install]
WantedBy=multi-user.target
```


And start the frontend service by running:

```bash
# systemctl daemon-reload
# systemctl enable --now marble-front
```

### Check that the frontend is runing

```bash
$  curl localhost:3000/healthcheck
OK
```

## Run the migrations

In order to populate the database with the required schema (and to upgrade it when upgrading Marble), you can run the `marble-migrate` service:

```bash
# systemctl start marble-migrate
# systemctl restart marble-api marble-worker
```
