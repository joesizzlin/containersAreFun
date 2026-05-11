set -e

IMAGE_NAME="juice-shop"
CONTAINER_NAME="juice-shop-dev"
WORKSPACE_DIR="$HOME/workspaces/juice_shop_workspace"
PORT=3000

echo "=== Ensuring workspace directory exists ==="
mkdir -p "$WORKSPACE_DIR"

echo "=== Building Docker image: $IMAGE_NAME ==="
docker build -t "$IMAGE_NAME" .

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

echo "=== Starting Docker container: $CONTAINER_NAME ==="
docker run -it --rm \
  --name "$CONTAINER_NAME" \
  -p "$PORT":3000 \
  -v "$WORKSPACE_DIR":/workspace \
  "$IMAGE_NAME"

echo "=== Juice Shop container $CONTAINER_NAME finished running ==="
