#!/bin/bash

# CONSTS
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color
# HELPER FUNCTIONS
prompt_user() {
    local message=$1
    # Ask for confirmation
    echo -e "${YELLOW}${message}${NC}"
    read choice
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
    echo -e "${GREEN}$1${NC}"
}

log_error() {
  echo -e "${RED}$1${NC}"
}

# MAIN SCRIPT
log_info "Configuring docker"
# install docker
while true; do
    prompt_user "Do you want to install docker? [Y/n]  "
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
    prompt_user "Do you want to install docker compose? [Y/n]  "
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
    prompt_user "Do you want to add current user to docker group (for running docker commands without sudo)? [Y/n]  "
    case $? in
        0)
          bash ./commands/add_user_to_docker_group.bash $SUDO_USER
          break ;;
        1) break ;;
        *) continue ;;
    esac
done

# an empty array to store selected services
declare -A services

# services selection
log_info "Select services"
while true; do
    prompt_user "Do you want to add laravel? [Y/n] (no)  "
    case $? in
        0)
          services["laravel"]=1
          break ;;
        *)
          services["laravel"]=0
          break ;;
    esac
done
while true; do
    prompt_user "Do you want to add flask? [Y/n] (no)  "
    case $? in
        0)
          services["flask"]=1
          break ;;
        *)
          services["flask"]=0
          break ;;
    esac
done
while true; do
    prompt_user "Do you want to add vue? [Y/n] (no)  "
    case $? in
        0)
          services["vue"]=1
          break ;;
        *)
          services["vue"]=0
          break ;;
    esac
done
while true; do
    prompt_user "Do you want to add redis? [Y/n] (no)  "
    case $? in
        0)
          services["redis"]=1
          break ;;
        *)
          services["redis"]=0
          break ;;
    esac
done
while true; do
    prompt_user "Do you want to add postgres? [Y/n] (no)  "
    case $? in
        0)
          services["pgsql"]=1
          break ;;
        *)
          services["pgsql"]=0
          break ;;
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
      log_error "Directory already exists."
  else
    break
  fi
done

# Create app path
log_info "Creating $app_path"
mkdir $app_path
log_info "$app_path created"

# Copy config files
# Common
cp ./config/docker-compose.yml "$app_path/docker-compose.yml"
# Nginx
mkdir -p "$app_path/nginx/conf.d"

if [[ "${services["laravel"]}" -eq 1 ]]; then
  # Create fresh laravel project
  while true; do
      prompt_user "Create fresh Laravel project at $app_path/laravel? [Y/n]  "
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
  cp ./config/services/laravel/Dockerfile "$app_path/laravel/Dockerfile"
  cp ./config/services/laravel/laravel.conf "$app_path/nginx/conf.d/laravel.conf"
  cp ./config/services/laravel/docker-compose.yml "$app_path/laravel/docker-compose.yml"
  log_info "Laravel configured"
fi

if [[ "${services["flask"]}" -eq 1 ]]; then
  # Copy config files
  cp -a ./config/services/flask "$app_path/flask"
  cp ./config/services/flask/flask.conf "$app_path/nginx/conf.d/flask.conf"
  cp ./config/services/flask/docker-compose.yml "$app_path/flask/docker-compose.yml"
  log_info "Flask configured"
fi

if [[ "${services["vue"]}" -eq 1 ]]; then
  # Create fresh vue project
  while true; do
      prompt_user "Create fresh Vue.js project at $app_path/vue? [Y/n]  "
      case $? in
          0)
            log_info "Creating fresh Vue.js project"
            bash ./commands/create_fresh_vue_project.bash $app_path
            log_info "Fresh Vue.js project created"
            break ;;
          1) break ;;
          *) continue ;;
      esac
  done
  # Copy config files
  cp ./config/services/vue/Dockerfile "$app_path/vue/Dockerfile"
  cp ./config/services/vue/nginx.conf "$app_path/vue/nginx.conf"
  cp ./config/services/vue/vue.conf "$app_path/nginx/conf.d/vue.conf"
  cp ./config/services/vue/docker-compose.yml "$app_path/vue/docker-compose.yml"
  log_info "Vue configured"
fi

if [[ "${services["redis"]}" -eq 1 ]]; then
  # Copy config files
  mkdir "$app_path/redis"
  cp ./config/services/redis/.env "$app_path/redis/.env"
  cp ./config/services/redis/docker-compose.yml "$app_path/redis/docker-compose.yml"
  log_info "Redis configured"
fi

if [[ "${services["pgsql"]}" -eq 1 ]]; then
  # Copy config files
  mkdir "$app_path/pgsql"
  cp ./config/services/pgsql/.env "$app_path/pgsql/.env"
  cp ./config/services/pgsql/docker-compose.yml "$app_path/pgsql/docker-compose.yml"
  log_info "Postgres configured"
fi

cd $app_path

# Start the containers
log_info "Starting the containers"

# Command to build
compose_cmd="docker compose -f docker-compose.yml"

# Loop through the associative array and add -f parameters for services with value 1
for service in "${!services[@]}"; do
    if [[ "${services[$service]}" -eq 1 ]]; then
        compose_cmd+=" -f ./$service/docker-compose.yml"
    fi
done

# Add the final part of the command
compose_cmd+=" up -d"

# Run the composed command
echo "Running command: $compose_cmd"#todo rm
eval "$compose_cmd"

log_info "Containers started"

if [[ "${services["laravel"]}" -eq 1 ]]; then
  # Install Laravel dependencies todo remove from here
  log_info "Installing composer dependencies"
  docker exec app_laravel composer install
  log_info "Composer dependencies installed"
  # Run Laravel migrations
  log_info "Running migrations"
  docker exec app_laravel php artisan migrate
  log_info "Migrations ran"
fi


# todo chmod storage test
# todo ssl