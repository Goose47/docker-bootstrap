adduser dev
usermod -aG sudo dev
rsync --archive --chown=dev:dev ~/.ssh /home/dev

sudo bash init.bash