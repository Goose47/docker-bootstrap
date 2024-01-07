#heloe
This repository will help you to bootstrap new application on a fresh ubuntu server with:
- Laravel
- Nginx
- PostgreSQL
- Redis
- Flask
- Docker & Docker compose
##Prerequisites
You will need a non-root user with sudo permissions.
<br>Create user "dev":
```bash
adduser dev
```
Then add it to sudo group:
```bash
usermod -aG sudo dev
```
This command will copy root user ssh keys to dev user:
```bash
rsync --archive --chown=dev:dev ~/.ssh /home/dev
```
To start the script simply run:
```bash
sudo bash init.bash
```
Script will suggest to install docker, docker compose and create a fresh Laravel app.