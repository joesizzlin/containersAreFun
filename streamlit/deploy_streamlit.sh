#!/bin/bash
set -e

echo "This repository now provides two dedicated Streamlit deployment scripts:"
echo "  ./deploy_streamlit_docker.sh"
echo "  ./deploy_streamlit_podman.sh"
echo
if [ "$1" = "docker" ]; then
  exec ./deploy_streamlit_docker.sh
elif [ "$1" = "podman" ]; then
  exec ./deploy_streamlit_podman.sh
fi

echo "Usage: ./deploy_streamlit.sh [docker|podman]"
echo "Alternatively, call ./deploy_streamlit_docker.sh or ./deploy_streamlit_podman.sh directly."
exit 1
