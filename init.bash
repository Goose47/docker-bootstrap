#!/bin/bash

# Get the username of current user
username=$USER

# install docker
bash ./commands/install_docker.bash
# install docker compose
bash ./commands/install_docker_compose.bash
# add current user to docker group
bash ./commands/add_user_to_docker_group.bash username