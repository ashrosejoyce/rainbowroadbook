#!/usr/bin/env bash
set -euo pipefail

cd /opt/rainbowroadbook-deploy

: "${IMAGE_TAG:?IMAGE_TAG must be set}"

DJANGO_SECRET_KEY="$(gcloud secrets versions access latest \
  --secret=rainbowroadbook-django-secret-key \
  --project=agile-vortex-508316-k6)"
export DJANGO_SECRET_KEY IMAGE_TAG

gcloud auth print-access-token | sudo docker login \
  -u oauth2accesstoken --password-stdin https://us-central1-docker.pkg.dev

sudo --preserve-env=DJANGO_SECRET_KEY,IMAGE_TAG docker compose -f docker-compose.prod.yml pull
sudo --preserve-env=DJANGO_SECRET_KEY,IMAGE_TAG docker compose -f docker-compose.prod.yml up -d --remove-orphans
sudo docker image prune -af
sudo --preserve-env=DJANGO_SECRET_KEY,IMAGE_TAG docker compose -f docker-compose.prod.yml ps