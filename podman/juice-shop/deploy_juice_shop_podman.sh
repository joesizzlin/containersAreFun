#!/bin/bash
set -euo pipefail

IMAGE_NAME="juice-shop"
CONTAINER_NAME="juice-shop-dev"
PORT=3000

echo "=== Using container runtime: podman (rootless) ==="
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
# Bind loopback only. Juice Shop is intentionally vulnerable; publishing it
# on 0.0.0.0 exposes it to anything your Azure NSG allows. The SSH -L tunnel
# above still reaches 127.0.0.1 on the VM, so nothing is lost.
podman run -it --rm \
  --name "$CONTAINER_NAME" \
  --cap-drop=ALL \
  --security-opt=no-new-privileges \
  -p 127.0.0.1:"$PORT":3000 \
  "$IMAGE_NAME"

echo "=== Juice Shop container $CONTAINER_NAME finished running ==="
