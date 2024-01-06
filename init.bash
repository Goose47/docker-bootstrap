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