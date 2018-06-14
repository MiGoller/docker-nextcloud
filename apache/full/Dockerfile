#
# Builds a custom docker image for latest Nextcloud Full Apache
#

FROM migoller/nextcloud:apache-preview

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

# =============================================================================
#                           SMB related stuff ...
# =============================================================================

# Install SMB related packages
RUN apt-get install -y \
    libsmbclient-dev \
    smbclient 

RUN pecl install smbclient \
    && docker-php-ext-enable smbclient

# cleanup apt lists
RUN rm -rf /var/lib/apt/lists/*
