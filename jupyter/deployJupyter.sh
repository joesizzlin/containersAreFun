#!/bin/bash
set -e

echo "This repository now provides two dedicated Jupyter deployment scripts:"
echo "  ./deploy_jupyter_docker.sh"
echo "  ./deploy_jupyter_podman.sh"
echo
if [ "$1" = "docker" ]; then
  exec ./deploy_jupyter_docker.sh
elif [ "$1" = "podman" ]; then
  exec ./deploy_jupyter_podman.sh
fi

echo "Usage: ./deployJupyter.sh [docker|podman]"
echo "Alternatively, call ./deploy_jupyter_docker.sh or ./deploy_jupyter_podman.sh directly."
exit 1
