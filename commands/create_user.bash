#!/bin/bash
adduser sammy
usermod -aG sudo sammy
# copies root user ssh key to sammy
rsync --archive --chown=sammy:sammy ~/.ssh /home/sammy