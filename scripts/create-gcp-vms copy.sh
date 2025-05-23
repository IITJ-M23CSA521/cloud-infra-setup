#!/bin/bash

# GCP CONFIG
PROJECT_ID="vcc-m23csa521"
ZONE="us-west4-c"
MACHINE_TYPE="e2-medium"
IMAGE_FAMILY="ubuntu-2004-lts"
IMAGE_PROJECT="ubuntu-os-cloud"
BOOT_DISK_SIZE="10GB"
BOOT_DISK_TYPE="pd-balanced"

# COMMON METADATA
STARTUP_SCRIPT='#! /bin/bash
  sudo apt-get update && sudo apt-get install -y python3'

create_instance() {
  NAME=$1
  IS_SPOT=$2

  # Common options
  OPTIONS=(
    --project="$PROJECT_ID"
    --zone="$ZONE"
    --machine-type="$MACHINE_TYPE"
    --image-family="$IMAGE_FAMILY"
    --image-project="$IMAGE_PROJECT"
    --boot-disk-size="$BOOT_DISK_SIZE"
    --boot-disk-type="$BOOT_DISK_TYPE"
    --tags=k8s
    --metadata=startup-script="$STARTUP_SCRIPT",enable-osconfig=TRUE
    --scopes=https://www.googleapis.com/auth/cloud-platform
    --shielded-secure-boot
    --shielded-vtpm
    --shielded-integrity-monitoring
  )

  if [ "$IS_SPOT" = true ]; then
    OPTIONS+=(
      --provisioning-model=SPOT
      --instance-termination-action=STOP
      --maintenance-policy=TERMINATE
    )
  fi

  echo "➡️ Creating instance: $NAME (SPOT=$IS_SPOT)"
  gcloud compute instances create "$NAME" "${OPTIONS[@]}"
}

echo "🚀 Creating Kubernetes Master Node (SPOT)..."
create_instance "k8s-master" true

echo "🚀 Creating Kubernetes Worker Nodes (SPOT)..."
create_instance "k8s-worker-1" true
create_instance "k8s-worker-2" true

echo "✅ All SPOT VMs created. Run 'gcloud compute instances list' to verify."
