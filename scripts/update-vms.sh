#!/bin/bash

PROJECT_ID="vcc-m23csa521"
ZONE="us-west4-c"
KEY_FILE="$HOME/temp_key.pub"

echo "🔑 Updating SSH keys for all VMs..."

gcloud compute instances add-metadata k8s-master \
  --zone $ZONE \
  --metadata-from-file ssh-keys=$KEY_FILE \
  --project $PROJECT_ID

gcloud compute instances add-metadata k8s-worker-1 \
  --zone $ZONE \
  --metadata-from-file ssh-keys=$KEY_FILE \
  --project $PROJECT_ID

gcloud compute instances add-metadata k8s-worker-2 \
  --zone $ZONE \
  --metadata-from-file ssh-keys=$KEY_FILE \
  --project $PROJECT_ID

echo "✅ SSH keys updated."
