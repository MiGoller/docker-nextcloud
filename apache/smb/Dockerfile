#
# Builds a custom docker image for latest Nextcloud SMB Apache
#

FROM nextcloud:apache

LABEL description="A server software for creating file hosting services" \
      Author="MiGoller"

# setup additional apt repos and update package list
RUN apt-get update

# SMB related stuff ...
# install SMB related packages
RUN apt-get install -y \
#       libsmbclient-dev \
        smbclient 

#RUN pecl install imagick smbclient \
#    && docker-php-ext-enable smbclient

# cleanup apt lists
RUN rm -rf /var/lib/apt/lists/*

# set recommended PHP.ini settings
# see https://docs.nextcloud.com/server/12/admin_manual/configuration_server/server_tuning.html#enable-php-opcache
COPY ./config/php/conf.d/apcu.ini /php/conf.d/
COPY ./config/php/conf.d/opcache.ini /php/conf.d/
