#!/bin/bash
set -euo pipefail

IMAGES=(
  "digital-detective"
  "juice-shop"
  "jupyter-py-lab"
  "streamlit-app"
  "vscode-server"
)

# NOTE: rootless podman keeps per-user storage under ~/.local/share/containers.
# This only cleans the invoking user's containers/images - running it as root
# (or as another user) touches a completely separate store.
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

# Rebuilds leave dangling layers behind; prune them and the build cache.
echo "=== Removing dangling images and build cache ==="
podman image prune -f
podman system prune -f --volumes=false || true
echo ""

echo "=== Podman cleanup complete ==="
echo "Remaining images:"
podman image ls
