#!/bin/bash
set -euo pipefail

IMAGE_NAME="jupyter-py-lab"
CONTAINER_NAME="jupyterlab-dev"
# Use the first script argument as the workspace directory if provided; otherwise fall back to the default path.
WORKSPACE_DIR="${1:-$HOME/workspaces/jupyter_workspace}"
PORT=8888

echo "=== Using container runtime: podman (rootless) ==="
echo "=== Ensuring workspace directory exists ==="
mkdir -p "$WORKSPACE_DIR"

echo "=== Building image: $IMAGE_NAME ==="
podman build -t "$IMAGE_NAME" .

echo "=== Be sure to tunnel to as localhost, opening another terminal window is fine ==="
sleep 1
echo "=== Copy and paste --> ssh -L $PORT:localhost:$PORT $USER@<YOUR_VM_IP> ==="
sleep 2
echo "=== Soon you will see something like http://127.0.0.1:$PORT/lab?token=<STUFF> to paste in your browser ==="
echo "=== With Podman, the first deployment and key assignment will take a moment ==="
sleep 1
echo "=== use CTRL+c when you are done ==="
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
# --userns=keep-id:uid=1000,gid=1000 maps YOUR host UID to container UID 1000
# (devuser). Without it, container UID 1000 lands on a subuid (~100999) that
# does not own $WORKSPACE_DIR, and JupyterLab fails to write its runtime dirs.
podman run -it --rm \
  --name "$CONTAINER_NAME" \
  --userns=keep-id:uid=1000,gid=1000 \
  --cap-drop=ALL \
  --security-opt=no-new-privileges \
  -p 127.0.0.1:"$PORT":8888 \
  -v "$WORKSPACE_DIR":/workspace:Z \
  "$IMAGE_NAME"

echo "=== JupyterLab container $CONTAINER_NAME finished running ==="
