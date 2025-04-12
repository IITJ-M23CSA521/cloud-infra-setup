#!/bin/bash

# CONFIG
PROJECT_ID="vcc-m23csa521"
ZONE="us-west4-c"
VM_NAMES=("k8s-master" "k8s-worker-1" "k8s-worker-2")

# DELETE
echo "🧨 Deleting Kubernetes VMs..."
for VM in "${VM_NAMES[@]}"; do
  echo "⛔ Deleting $VM..."
  gcloud compute instances delete "$VM" \
    --project="$PROJECT_ID" \
    --zone="$ZONE" \
    --quiet || echo "⚠️ $VM may not exist"
done

echo "✅ Deletion complete."
