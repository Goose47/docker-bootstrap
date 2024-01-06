FROM php:8.1-fpm

WORKDIR /var/www/app/laravel

RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    libzip-dev \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    curl \
    libpq-dev \
    libxml2

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install extensions
RUN docker-php-ext-install pgsql pdo_pgsql zip exif pcntl gd

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer


EXPOSE 9000
CMD ["php-fpm"]