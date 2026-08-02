#!/bin/bash
set -euo pipefail

IMAGE_NAME="vscode-server"
CONTAINER_NAME="vscode-dev"
WORKSPACE_DIR="${1:-$HOME/workspaces/vscode_workspace}"
PORT=8080
SECRET_NAME="vscode-password"

if [ -z "${PASSWORD:-}" ]; then
  read -s -p "Enter code-server password: " PASSWORD
  echo
fi

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

# Store the password as a podman secret instead of passing -e PASSWORD=...,
# which would expose it via `podman inspect`, /proc/1/environ and shell history.
printf '%s' "$PASSWORD" | podman secret create --replace "$SECRET_NAME" -
unset PASSWORD
trap 'podman secret rm "$SECRET_NAME" >/dev/null 2>&1 || true' EXIT

echo "=== Starting container: $CONTAINER_NAME ==="
podman run -it --rm \
  --name "$CONTAINER_NAME" \
  --userns=keep-id:uid=1000,gid=1000 \
  --cap-drop=ALL \
  --security-opt=no-new-privileges \
  -p 127.0.0.1:"$PORT":8080 \
  --secret "$SECRET_NAME",type=env,target=PASSWORD \
  -v "$WORKSPACE_DIR":/workspace:Z \
  "$IMAGE_NAME"

echo "=== VS Code Server container $CONTAINER_NAME finished running ==="
