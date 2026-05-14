#!/bin/bash
set -e

IMAGES=(
  "digital-detective"
  "juice-shop"
  "jupyter-py-lab"
  "streamlit-app"
  "vscode-server"
)

echo "=== Docker Cleanup Script ==="
echo ""

# Remove stopped containers
echo "=== Removing stopped containers ==="
docker container prune -f
echo "✓ Stopped containers removed"
echo ""

# Remove images
echo "=== Removing container images ==="
for image in "${IMAGES[@]}"; do
  if docker image inspect "$image" &>/dev/null; then
    echo "Removing image: $image"
    docker rmi -f "$image"
    echo "✓ $image removed"
  else
    echo "⊘ Image not found: $image (skipping)"
  fi
done
echo ""

echo "=== Docker cleanup complete ==="
echo "Remaining images:"
docker image ls
