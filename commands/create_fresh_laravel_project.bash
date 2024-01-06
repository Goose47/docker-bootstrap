#!/bin/bash
# Check if the script is provided with at least one argument
if [ $# -eq 0 ]; then
    echo "Usage: $0 <path>"
    exit 1
fi

path=$1

# build image
docker build -t laravel_bootstrap_image ./services/laravel/bootstrap
# run image which installs composer and creates fresh laravel project in /app with volume that copies it to the $path
docker run -v $path:/app laravel_bootstrap_image
# remove the image after the container did it work
docker image rm laravel_bootstrap_image