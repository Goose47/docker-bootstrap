FROM php:8.1-fpm

# Set a working directory
WORKDIR /app

# Install the required package
RUN apt update
RUN apt install -y \
    git \
    unzip \
    curl \
    libcurl4-openssl-dev \
    libxml2-dev \
    libzip-dev

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
# Install php extensions
RUN docker-php-ext-install curl xml zip