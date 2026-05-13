#!/bin/bash
set -e

echo "This repository now provides two dedicated Juice Shop deployment scripts:"
echo "  ./deploy_juice_shop_docker.sh"
echo "  ./deploy_juice_shop_podman.sh"
echo
if [ "$1" = "docker" ]; then
  exec ./deploy_juice_shop_docker.sh
elif [ "$1" = "podman" ]; then
  exec ./deploy_juice_shop_podman.sh
fi

echo "Usage: ./deploy_juice_shop.sh [docker|podman]"
echo "Alternatively, call ./deploy_juice_shop_docker.sh or ./deploy_juice_shop_podman.sh directly."
exit 1
