set -e

IMAGE_NAME="jupyter-py-lab"
CONTAINER_NAME="jupyterlab-dev"
WORKSPACE_DIR="$HOME/workspaces/jupyter_workspace"
PORT=8888

echo "=== Ensuring workspace directory exists ==="
mkdir -p "$WORKSPACE_DIR"

echo "=== Building Docker image: $IMAGE_NAME ==="
docker build -t "$IMAGE_NAME" .

echo "=== Be sure to tunnel to as localhost, opening another terminal window is fine ==="
sleep 1
echo "=== Copy and paste --> ssh -L "$PORT":localhost:"$PORT" "$USER"@<YOUR_VM_IP> ==="
sleep 2
echo "=== Soon you will see something like "http://127.0.0.1:"$PORT"/lab?token="<STUFF>"" to paste in web browser ==="
sleep 1
echo "=== use CTRL+c when you are done ==="
sleep 2
echo "=== 3... ==="
sleep 1
echo "=== 2... ==="
sleep 1
echo "=== 1... ==="
echo "=== MUDKIP!! ==="

echo "=== Starting Docker image: #$IMAGE_NAME ==="
docker run -it --rm \
  --name "$CONTAINER_NAME" \
  -p "$PORT":8888 \
  -v "$WORKSPACE_DIR":/workspace \
  "$IMAGE_NAME"

echo "=== JupyterLab container "$CONTAINER_NAME" finished running ===" 
