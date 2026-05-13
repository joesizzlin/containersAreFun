#!/bin/bash
set -e

echo "This repository now provides two dedicated VS Code deployment scripts:"
echo "  ./deploy_vscode_docker.sh"
echo "  ./deploy_vscode_podman.sh"
echo
if [ "$1" = "docker" ]; then
  exec ./deploy_vscode_docker.sh
elif [ "$1" = "podman" ]; then
  exec ./deploy_vscode_podman.sh
fi

echo "Usage: ./deploy_vscode.sh [docker|podman]"
echo "Alternatively, call ./deploy_vscode_docker.sh or ./deploy_vscode_podman.sh directly."
exit 1
