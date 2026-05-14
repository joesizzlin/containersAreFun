#!/bin/bash
set -e

IMAGE_NAME="digital-detective"
CONTAINER_NAME="digital-detective-dev"
EVIDENCE_DIR="$HOME/workspaces/digital-detective/evidence"
TOOLS_DIR="$HOME/workspaces/digital-detective/tools"
OUTPUT_DIR="$HOME/workspaces/digital-detective/output"

echo "=== Using container runtime: docker ==="
echo "=== Ensuring workspace directories exist ==="
mkdir -p "$EVIDENCE_DIR"
mkdir -p "$TOOLS_DIR"
mkdir -p "$OUTPUT_DIR"

echo "=== Building image: $IMAGE_NAME ==="
docker build -t "$IMAGE_NAME" .

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
sleep 2
echo "=== MUDKIP!! ==="
sleep 1

docker run -it --rm \
  --name "$CONTAINER_NAME" \
  -v "$EVIDENCE_DIR":/mnt/evidence \
  -v "$TOOLS_DIR":/mnt/tools \
  -v "$OUTPUT_DIR":/mnt/output \
  "$IMAGE_NAME"

echo "=== Digital detective container $CONTAINER_NAME finished running ==="
