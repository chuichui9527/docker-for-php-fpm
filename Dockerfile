FROM php:7.2.21-fpm
MAINTAINER chuichui
#安装GD库文件
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        git \
    && docker-php-ext-install -j$(nproc) iconv \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    #安装yaf
    && cd /usr/local/src \
    && git  clone https://github.com/magicdragoon/yaf \
    && cd yaf \
    && phpize \
    && ./configure \
    && make \ 
    && make install \
    && docker-php-ext-enable yaf \
    #安装redis
    && pecl install igbinary \
    && docker-php-ext-enable igbinary \
    && (pecl install redis <<EOF \
    yes\
    yes\
    EOF) \
    && docker-php-ext-enable redis \
    #安装swoole
    && docker-php-ext-install sockets \
    && docker-php-ext-enable sockets \
    && apt-get install -y zlib1g.dev  \
    && (pecl install swoole <<EOF \
    yes\
    yes\
    yes\
    yes\
    EOF) \
    && docker-php-ext-enable swoole \
    #安装mongoDB
    && pecl install mongodb \
    && docker-php-ext-enable mongodb \
    #日常清理
    && apt-get remove -y git \
    && rm -rf /usr/local/src/*





