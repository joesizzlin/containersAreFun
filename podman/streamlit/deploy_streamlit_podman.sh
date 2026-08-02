#!/bin/bash
set -euo pipefail

IMAGE_NAME="streamlit-app"
CONTAINER_NAME="streamlit-dev"
# Use the first script argument as the workspace directory if provided; otherwise fall back to the default path.
WORKSPACE_DIR="${1:-$HOME/workspaces/streamlit_workspace}"
PORT=8501

echo "=== Using container runtime: podman (rootless) ==="
echo "=== Ensuring workspace directory exists ==="
mkdir -p "$WORKSPACE_DIR"

echo "=== Building image: $IMAGE_NAME ==="
podman build -t "$IMAGE_NAME" .

echo "=== Be sure to tunnel to this port in another terminal ==="
sleep 1
echo "=== Copy and paste --> ssh -L $PORT:localhost:$PORT $USER@<YOUR_VM_IP> ==="
sleep 2
echo "=== Then open http://127.0.0.1:$PORT in your browser ==="
sleep 1
echo "=== CTRL+C when you're done ==="
sleep 2
echo "=== 3... ==="
sleep 2
echo "=== 2... ==="
sleep 2
echo "=== 1... ==="
sleep 2
echo "=== MUDKIP!! ==="
sleep 1

echo "=== Starting container: $CONTAINER_NAME ==="
# Keep the host UID/GID mapped into the container so the mounted workspace stays writable
# for the user running this script; without it, files may be owned by a different UID/GID.
podman run -it --rm \
  --name "$CONTAINER_NAME" \
  --userns=keep-id:uid=1000,gid=1000 \
  --cap-drop=ALL \
  --security-opt=no-new-privileges \
  -p 127.0.0.1:"$PORT":8501 \
  -v "$WORKSPACE_DIR":/workspace:Z \
  "$IMAGE_NAME"

echo "=== Streamlit container $CONTAINER_NAME finished running ==="
