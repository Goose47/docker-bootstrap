#!/bin/bash
# Check if the script is provided with at least one argument
if [ $# -eq 0 ]; then
    echo "Usage: $0 <path>"
    exit 1
fi

path=$1

# build image
docker build -t laravel_bootstrap_image ./config/services/laravel/bootstrap
# run container with command which creates fresh laravel project in /app with volume that copies it to the $path
docker run -v $path:/app laravel_bootstrap_image composer create-project laravel/laravel .
# remove the image after the container did its work
docker image rm -f laravel_bootstrap_image