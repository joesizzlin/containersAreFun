#!/bin/bash
set -e

IMAGES=(
  "digital-detective"
  "juice-shop"
  "jupyter-py-lab"
  "streamlit-app"
  "vscode-server"
)

echo "=== Podman Cleanup Script ==="
echo ""

# Remove stopped containers
echo "=== Removing stopped containers ==="
podman container prune -f
echo "✓ Stopped containers removed"
echo ""

# Remove images
echo "=== Removing container images ==="
for image in "${IMAGES[@]}"; do
  if podman image inspect "$image" &>/dev/null; then
    echo "Removing image: $image"
    podman rmi -f "$image"
    echo "✓ $image removed"
  else
    echo "⊘ Image not found: $image (skipping)"
  fi
done
echo ""

echo "=== Podman cleanup complete ==="
echo "Remaining images:"
podman image ls
