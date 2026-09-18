#!/usr/bin/env bash
set -euo pipefail

PROJECT_ID="agile-vortex-508316-k6"
REGION="us-central1"
ZONE="us-central1-a"
VM_NAME="rainbowroadbook-app-vm"
IP_NAME="rainbowroadbook-app-ip"
SERVICE_ACCOUNT="523773459301-compute@developer.gserviceaccount.com"

echo "==> Reserving static external IP: ${IP_NAME}"
gcloud compute addresses create "${IP_NAME}" \
  --region="${REGION}" \
  --project="${PROJECT_ID}"

echo "==> Creating VM: ${VM_NAME}"
gcloud compute instances create "${VM_NAME}" \
  --project="${PROJECT_ID}" \
  --zone="${ZONE}" \
  --machine-type=e2-small \
  --image-family=debian-12 \
  --image-project=debian-cloud \
  --boot-disk-size=10GB \
  --boot-disk-type=pd-balanced \
  --address="${IP_NAME}" \
  --tags=rainbowroadbook-app \
  --scopes=cloud-platform \
  --metadata-from-file=startup-script=scripts/install-docker.sh

echo "==> Granting roles/cloudsql.client to ${SERVICE_ACCOUNT}"
gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
  --member="serviceAccount:${SERVICE_ACCOUNT}" \
  --role="roles/cloudsql.client"

echo "==> Infra provisioned. Manual steps still required (not automated here):"
echo "    1. SSH in: gcloud compute ssh ${VM_NAME} --zone=${ZONE}"
echo "    2. Generate a deploy key and add it as a read-only GitHub deploy key"
echo "    3. git clone into /opt/rainbowroadbook"
echo "    4. Create .env.prod with real production secrets (never committed)"