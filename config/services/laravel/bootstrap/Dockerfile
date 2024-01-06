FROM ubuntu:latest

# Install the required package
RUN apt update

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set a working directory
WORKDIR /app

RUN composer create-project laravel/laravel .