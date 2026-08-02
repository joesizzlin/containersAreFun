#!/bin/bash
set -euo pipefail

IMAGE_NAME="juice-shop"
POD_NAME="juice-shop-pod"
CONTAINER_NAME="juice-shop-dev"
OLLAMA_CONTAINER="juice-shop-ollama"
OLLAMA_IMAGE="docker.io/ollama/ollama:latest"
OLLAMA_MODEL="${OLLAMA_MODEL:-llama3.2:3b}"
PORT=3000

# Juice Shop reads ALCHEMY_API_KEY from its environment to enable the web3
# challenges ("Mint the Honey Pot", "Wallet Depletion"). Never hardcode it
# here. Either export it before running this script, or drop a line
# ALCHEMY_API_KEY=... into the file below and chmod 600 it.
SECRET_FILE="${HOME}/.config/juice-shop/alchemy.env"
ALCHEMY_API_KEY="${ALCHEMY_API_KEY:-}"
if [[ -z "$ALCHEMY_API_KEY" && -r "$SECRET_FILE" ]]; then
  # shellcheck disable=SC1090
  source "$SECRET_FILE"
  ALCHEMY_API_KEY="${ALCHEMY_API_KEY:-}"
fi

cleanup() {
  echo "=== Tearing down pod: $POD_NAME ==="
  podman pod rm -f "$POD_NAME" >/dev/null 2>&1 || true
}
trap cleanup EXIT

echo "=== Using container runtime: podman (rootless) ==="
echo "=== Building image: $IMAGE_NAME ==="
podman build -t "$IMAGE_NAME" .

podman pod rm -f "$POD_NAME" >/dev/null 2>&1 || true

# Juice Shop's LLM challenges expect an OpenAI-compatible endpoint at
# http://localhost:11434/v1. "localhost" resolves inside the container's
# network namespace, so an Ollama instance on the VM host is unreachable.
# Containers in a pod share one namespace, so running Ollama as a pod member
# makes that URL resolve with no application config changes.
#
# Ports publish on the POD, not on member containers. Bind loopback only:
# The SSH -L tunnel below still reaches 127.0.0.1 on the VM, so nothing is lost. 
# Note that 11434 is deliberately
# NOT published -- Ollama stays reachable only from inside the pod.
echo "=== Creating pod: $POD_NAME ==="
podman pod create --name "$POD_NAME" -p 127.0.0.1:"$PORT":3000

echo "=== Starting Ollama in pod ==="
podman run -d --pod "$POD_NAME" \
  --name "$OLLAMA_CONTAINER" \
  --security-opt=no-new-privileges \
  -v ollama-models:/root/.ollama \
  "$OLLAMA_IMAGE"

echo -n "=== Waiting for Ollama on :11434 "
for _ in $(seq 1 60); do
  if podman exec "$OLLAMA_CONTAINER" ollama list >/dev/null 2>&1; then
    echo " ready ==="
    break
  fi
  echo -n "."
  sleep 1
done

echo "=== Pulling model: $OLLAMA_MODEL (cached in volume after first run) ==="
podman exec "$OLLAMA_CONTAINER" ollama pull "$OLLAMA_MODEL"

RUN_ENV=()
if [[ -n "$ALCHEMY_API_KEY" ]]; then
  RUN_ENV+=(-e "ALCHEMY_API_KEY=$ALCHEMY_API_KEY")
  echo "=== ALCHEMY_API_KEY loaded: web3 challenges enabled ==="
else
  echo "=== No ALCHEMY_API_KEY found: web3 challenges will warn ==="
fi

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
# No -p here: the pod owns the port mapping. Podman rejects --publish on a
# container that is already a pod member.
podman run -it --rm --pod "$POD_NAME" \
  --name "$CONTAINER_NAME" \
  --cap-drop=ALL \
  --security-opt=no-new-privileges \
  "${RUN_ENV[@]}" \
  "$IMAGE_NAME"

echo "=== Juice Shop container $CONTAINER_NAME finished running ==="
