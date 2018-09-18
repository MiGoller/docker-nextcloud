#
# Builds a custom docker image for latest Nextcloud SMB Apache
#

FROM migoller/nextcloud:14-apache

LABEL description="A server software for creating file hosting services" \
      Author="MiGoller"

# =============================================================================
#                           SMB related stuff ...
# =============================================================================

# Install SMB related packages
RUN apt-get update && apt-get install -y \
      libsmbclient-dev \
      smbclient 

RUN pecl install smbclient \
    && docker-php-ext-enable smbclient

# cleanup apt lists
RUN rm -rf /var/lib/apt/lists/*
