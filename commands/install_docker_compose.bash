#!/bin/bash
# Use the following command to download:
mkdir -p /home/$SUDO_USER/.docker/cli-plugins/
curl -SL https://github.com/docker/compose/releases/download/v2.3.3/docker-compose-linux-x86_64 -o /home/$SUDO_USER/.docker/cli-plugins/docker-compose
# Next, set the correct permissions so that the docker compose command is executable:
chmod +x /home/$SUDO_USER/.docker/cli-plugins/docker-compose