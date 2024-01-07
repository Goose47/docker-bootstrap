#!/bin/bash

# CONSTS
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color
# HELPER FUNCTIONS
prompt_user() {
    local message=$1
    # Ask for confirmation
    read -p "${YELLOW}${message}${NC}" choice
    case "$choice" in
          [yY] | [yY][eE][sS])
            # operation confirmed
            return 0
            ;;
          [nN] | [nN][oO])
            # operation canceled
            return 1
            ;;
          *)
            # invalid choice
            return 2
            ;;
    esac
}
log_info() {
    echo -e "${GREEN}${$1}${NC}"
}

# MAIN SCRIPT

log_info "Configuring docker"
# install docker
while true; do
    prompt_user "Do you want to install docker? (Y/n)  "
    case $? in
        0)
          bash ./commands/install_docker.bash
          break ;;
        1) break ;;
        *) continue ;;
    esac
done

# install docker compose
while true; do
    prompt_user "Do you want to install install docker compose? (Y/n)  "
    case $? in
        0)
          bash ./commands/install_docker_compose.bash
          break ;;
        1) break ;;
        *) continue ;;
    esac
done

# add current user to docker group
while true; do
    prompt_user "Do you want to add current user to docker group (for running docker commands without sudo)? (Y/n)  "
    case $? in
        0)
          bash ./commands/add_user_to_docker_group.bash $SUDO_USER
          break ;;
        1) break ;;
        *) continue ;;
    esac
done

# Getting application name
log_info "Docker configured, creating application..."
read -p "Enter application name (default: app) => " app_name

# If no input is provided, set a default value
if [ -z "$app_name" ]; then
    app_name="app"
fi

# Getting application path
while true; do
  read -p "Enter application path (default: /home/$SUDO_USER/$app_name) => " app_path

  # If no input is provided, set a default value
  if [ -z "$app_path" ]; then
      app_path="/home/$SUDO_USER/$app_name"
  fi

  if [ -d "$app_path" ]; then
      echo "Directory already exists."
  else
    break
  fi
done

# Create app path
log_info "Creating $app_path"
mkdir $app_path
log_info "$app_path created"

# Create fresh laravel project
while true; do
    prompt_user "Create fresh Laravel project at $app_path/laravel? (Y/n)  "
    case $? in
        0)
          log_info "Creating fresh Laravel project"
          bash ./commands/create_fresh_laravel_project.bash $app_path
          log_info "Fresh Laravel project created"
          break ;;
        1) break ;;
        *) continue ;;
    esac
done

# Copy config files
log_info "Copying configuration files"
cp ./config/docker-compose.yml "$app_path/docker-compose.yml"
cp ./config/services/laravel/Dockerfile "$app_path/laravel/Dockerfile"
mkdir -p "$app_path/nginx/conf.d"
cp ./config/services/nginx/conf.d/nginx.conf "$app_path/nginx/conf.d/nginx.conf"
mkdir "$app_path/pgsql"
cp ./config/services/pgsql/.env "$app_path/pgsql/.env"
log_info "Configuration files copied"

cd $app_path
# Start the containers
log_info "Starting the containers"
docker compose up -d
log_info "Containers started"
# Install Laravel dependencies
log_info "Installing composer dependencies"
docker exec app_laravel composer install
log_info "Composer dependencies installed"
# Run Laravel migrations
log_info "Running migrations"
docker exec app_laravel php artisan migrate
log_info "Migrations ran"


# todo chmod storage test
# todo flask
# todo ssl
# todo colored messages
# todo services selection