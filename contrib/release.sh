#!/bin/sh

set -e

BACKEND=''
FRONTEND=''
MOTIVA=''

while [ $# -gt 0 ]; do
  case "$1" in
    --backend) BACKEND="$2" ;;
    --frontend) FRONTEND="$2" ;;
    --motiva) MOTIVA="$2" ;;

    *)
      echo "Unknown option: $1" >&2
      exit 1
  esac

  shift 2
done

[ -z "$BACKEND" ] && echo 'ERROR: backend version should be provided' && exit 1
[ -z "$FRONTEND" ] && echo 'ERROR: frontend version should be provided' && exit 1

git -C api fetch
git -C api checkout "$BACKEND"
git -C front fetch
git -C front checkout "$FRONTEND"

export BACKEND FRONTEND MOTIVA

for FILE in docker-compose.yaml docker-compose-dev.yaml; do
  yq -i '.x-backend-image-version.image = "europe-west1-docker.pkg.dev/marble-infra/marble/marble-backend:\(strenv(BACKEND))"' $FILE
  yq -i '.x-frontend-image-version.image = "europe-west1-docker.pkg.dev/marble-infra/marble/marble-frontend:\(strenv(FRONTEND))"' $FILE

  if [ -n "$MOTIVA" ]; then
    yq -i '.services.motiva.image = "ghcr.io/apognu/motiva:\(strenv(MOTIVA))"' $FILE
  fi
done

