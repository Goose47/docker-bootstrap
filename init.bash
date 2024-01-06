#!/bin/bash


# HELPER FUNCTIONS
prompt_user() {
    local message=$1
    # Ask for confirmation
    read -p "$message" choice
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

# MAIN SCRIPT

echo "Configuring docker..."
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
echo "Docker configured, creating application..."
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

  if [ -d "$directory" ]; then
      echo "Directory already exists."
  else
    break
  fi
done

# Create app path
echo "Creating $app_path"
mkdir $app_path
echo "$app_path created"

# Create fresh laravel project
echo "Creating fresh laravel project"
bash ./commands/create_fresh_laravel_project.bash $app_path
echo "Fresh laravel project created"

cd $app_path

