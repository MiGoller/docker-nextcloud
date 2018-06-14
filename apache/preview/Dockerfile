#
# Builds a custom docker image for latest Nextcloud "Apache" version.
#

FROM migoller/nextcloud:apache

LABEL description="A server software for creating file hosting services" \
      Author="MiGoller"

# =============================================================================
#                           PREVIEW related stuff ...
# =============================================================================

# Install PREVIEW related packages
RUN apt-get update && apt-get install -y ffmpeg libmagickwand-dev libgmp3-dev libc-client-dev

# Configure and install PHP-extensions for PREVIEW support 
RUN ln -s "/usr/include/$(dpkg-architecture --query DEB_BUILD_MULTIARCH)/gmp.h" /usr/include/gmp.h \
    && docker-php-ext-install bz2 gmp

RUN pecl install imagick \
    && docker-php-ext-enable imagick

# Cleanup apt lists
RUN rm -rf /var/lib/apt/lists/*
