#
# Builds a custom docker image for latest Nextcloud IMAP Apache
#

FROM migoller/nextcloud:13-apache

LABEL description="A server software for creating file hosting services" \
      Author="MiGoller"

# =============================================================================
#                           IMAP related stuff ...
# =============================================================================

# Install IMAP related packages
RUN apt-get update && apt-get install -y libc-client-dev libkrb5-dev

# Configure and install PHP-extensions for IMAP support
RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install imap

# cleanup apt lists
RUN rm -rf /var/lib/apt/lists/*
