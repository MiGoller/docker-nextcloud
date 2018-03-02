#
# Builds a custom docker image for latest Nextcloud Cron Apache
#

FROM nextcloud:apache

LABEL description="A server software for creating file hosting services" \
      Author="MiGoller"

# setup additional apt repos and update package list
RUN apt-get update

# CRON related stuff ...
# install CRON related packages
RUN apt-get install -y \
        supervisor \
        cron

# setup CRON job for nextcloud
RUN echo "*/15 * * * * su - www-data -s /bin/bash -c \"php -f /var/www/html/cron.php\""| crontab -

# set SUPERVISOR settings
RUN mkdir /var/log/supervisord /var/run/supervisord 
COPY ./config/supervisord/supervisord.conf /etc/supervisor/supervisord.conf

# cleanup apt lists
RUN rm -rf /var/lib/apt/lists/*

# set recommended PHP.ini settings
# see https://docs.nextcloud.com/server/12/admin_manual/configuration_server/server_tuning.html#enable-php-opcache
COPY ./config/php/conf.d/apcu.ini /php/conf.d/
COPY ./config/php/conf.d/opcache.ini /php/conf.d/

CMD ["/usr/bin/supervisord"]
