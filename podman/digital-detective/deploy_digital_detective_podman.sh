#!/bin/bash
set -euo pipefail

IMAGE_NAME="digital-detective"
CONTAINER_NAME="digital-detective-dev"
# Use the first script argument as the evidence directory if provided; otherwise fall back to the default path.
EVIDENCE_DIR="${1:-$HOME/workspaces/digital-detective/evidence}"
TOOLS_DIR="$HOME/workspaces/digital-detective/tools"
OUTPUT_DIR="$HOME/workspaces/digital-detective/output"

echo "=== Using container runtime: podman (rootless) ==="
echo "=== Ensuring workspace directories exist ==="
mkdir -p "$EVIDENCE_DIR"
mkdir -p "$TOOLS_DIR"
mkdir -p "$OUTPUT_DIR"

echo "=== Building image: $IMAGE_NAME ==="
podman build -t "$IMAGE_NAME" .

echo "=== Starting digital detective container: $CONTAINER_NAME ==="
echo "=== Mounted volumes:"
echo "    $EVIDENCE_DIR -> /mnt/evidence (evidence files)"
echo "    $TOOLS_DIR -> /mnt/tools (custom tools/scripts)"
echo "    $OUTPUT_DIR -> /mnt/output (results/output)"
sleep 2
echo "=== 3... ==="
sleep 2
echo "=== 2... ==="
sleep 2
echo "=== 1... ==="

# No --userns needed here: this image runs as container root, and under
# rootless podman container UID 0 already maps to your host UID.
# :Z relabels each mount for SELinux (RHEL enforcing) - without it the
# container gets AVC denials regardless of Unix permissions.
podman run -it --rm \
  --name "$CONTAINER_NAME" \
  --security-opt=no-new-privileges \
  -v "$EVIDENCE_DIR":/mnt/evidence:Z \
  -v "$TOOLS_DIR":/mnt/tools:Z \
  -v "$OUTPUT_DIR":/mnt/output:Z \
  "$IMAGE_NAME"

echo "=== Digital detective container $CONTAINER_NAME finished running ==="
