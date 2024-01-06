#!/bin/bash
# Check if the script is provided with at least one argument
if [ $# -eq 0 ]; then
    echo "Usage: $0 <path>"
    exit 1
fi

path="$1/laravel"

# build image
docker build -t laravel_bootstrap_image ./config/services/laravel/bootstrap
# run container with command which creates fresh laravel project in /app with volume that copies it to the $path
docker run -v $path:/app laravel_bootstrap_image composer create-project laravel/laravel .
# remove the image after the container did its work
docker image rm -f laravel_bootstrap_image

# chmod storage
chmod -R +rw "$path/storage"
# Changing the laravel .env variables
# Getting variables from pgsql config
source ./config/pgsql/.env
sed -i -e "s/^DB_CONNECTION=.*/DB_CONNECTION=pgsql/" \
       -e "s/^DB_HOST=.*/DB_HOST=pgsql/" \
       -e "s/^DB_PORT=.*/DB_PORT=5432/" \
       -e "s/^DB_DATABASE=.*/DB_DATABASE=${POSTGRES_DB:-override}/" \
       -e "s/^DB_USERNAME=.*/DB_USERNAME=${POSTGRES_USER:-override}/" \
       -e "s/^DB_PASSWORD=.*/DB_PASSWORD=${POSTGRES_PASSWORD:-override}/" \
       "$path/.env"