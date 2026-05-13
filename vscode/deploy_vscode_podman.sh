#!/bin/bash
set -e

IMAGE_NAME="vscode-server"
CONTAINER_NAME="vscode-dev"
WORKSPACE_DIR="$HOME/workspaces/vscode_workspace"
PORT=8080

if [ -z "$PASSWORD" ]; then
  read -s -p "Enter code-server password: " PASSWORD
  echo
fi

echo "=== Using container runtime: podman ==="
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
podman run -it --rm \
  --name "$CONTAINER_NAME" \
  -p "$PORT":8080 \
  -e PASSWORD="$PASSWORD" \
  -v "$WORKSPACE_DIR":/workspace \
  "$IMAGE_NAME"

echo "=== VS Code Server container $CONTAINER_NAME finished running ==="
