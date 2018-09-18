#
# Builds a custom docker image for latest Nextcloud "Apache" version.
#

FROM nextcloud:14-apache

LABEL description="A server software for creating file hosting services" \
      Author="MiGoller"

# Setup additional apt repos and update package list
RUN echo "deb http://ftp.debian.org/debian jessie-backports main" >> /etc/apt/sources.list \
    && apt-get update

# =============================================================================
#                           CRON related stuff ...
# =============================================================================

# Install CRON related packages
RUN apt-get install -y supervisor cron

# Setup CRON job for nextcloud
RUN echo "*/15 * * * * su - www-data -s /bin/bash -c \"php -f /var/www/html/cron.php\""| crontab -

# Set SUPERVISOR settings
RUN mkdir /var/log/supervisord /var/run/supervisord 
COPY ./config/supervisord/supervisord.conf /etc/supervisor/supervisord.conf

# Set recommended PHP.ini settings
# See https://docs.nextcloud.com/server/12/admin_manual/configuration_server/server_tuning.html#enable-php-opcache
COPY ./config/php/conf.d/apcu.ini /php/conf.d/
COPY ./config/php/conf.d/opcache.ini /php/conf.d/

CMD ["/usr/bin/supervisord"]
