#!/bin/bash
# Check if the script is provided with at least one argument
if [ $# -eq 0 ]; then
    echo "Usage: $0 <path>"
    exit 1
fi

path="$1/vue"

# build image
docker build -t vue_bootstrap_image ./config/services/vue/bootstrap
# run container with command which creates fresh vue project in /app with volume that copies it to the $path
docker run -it --rm -v $path:/app vue_bootstrap_image npm create vue@latest .
# remove the image after the container did its work
docker image rm -f vue_bootstrap_image