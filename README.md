# About this custom image for Nextcloud
This image is designed to be used in a micro-service environment with a so called "full" stack of features.
Many thanks to [Nextcloud](https://nextcloud.com/) for their great work!

# What is Nextcloud?
[![Build Status update.sh](https://doi-janky.infosiftr.net/job/update.sh/job/nextcloud/badge/icon)](https://doi-janky.infosiftr.net/job/update.sh/job/nextcloud)
[![Build Status Travis](https://travis-ci.org/nextcloud/docker.svg?branch=master)](https://travis-ci.org/nextcloud/docker)

A safe home for all your data. Access & share your files, calendars, contacts, mail & more from any device, on your terms.

![logo](https://cdn.rawgit.com/nextcloud/docker/57b5e03f2abe51f81aa9a5c80018d10b5ed1c353/logo.svg)

# How to use this image
This image is designed to be used in a micro-service environment. There are two versions of the image you can choose from.

The `apache` tag contains a full Nextcloud installation including an apache web server. It is designed to be easy to use and get's you running pretty fast. This is also the default for the `latest` tag and version tags that are not further specified.

The second option is a `fpm` container. It is based on the [php-fpm](https://hub.docker.com/_/php/) image and runs a fastCGI-Process that serves your Nextcloud page. To use this image it must be combined with any webserver that can proxy the http requests to the FastCGI-port of the container.

## Using the apache image
The apache image contains a webserver and exposes port 80. To start the container type:

```console
$ docker run -d -p 8080:80 migoller/nextcloud
```

Now you can access Nextcloud at http://localhost:8080/ from your host system.

# Adding Features
A lot of people want to use additional functionality inside their Nextcloud installation. If the image does not include the packages you need, you can easily build your own image on top of it.
Start your derived image with the `FROM` statement and add whatever you like.

```yaml
FROM nextcloud:apache

RUN ...

```
The [examples folder](https://github.com/nextcloud/docker/blob/master/.examples) gives a few examples on how to add certain functionalities, like including the cron job, smb-support or imap-authentication. 

This image provides a [Nextcloud 12 full image](https://github.com/nextcloud/docker/tree/master/.examples) with support for:
*   Cron jobs
*   Support for SMB/CIFS shares
*   IMAP-authentication
*   Preview of images and videos

For further details please have a look at [Nextcloud 12 full image Dockerfile](https://github.com/nextcloud/docker/blob/master/.examples/dockerfiles/full/apache/Dockerfile).

# Auto configuration via environment variables
The nextcloud image supports auto configuration via environment variables. You can preconfigure everything that is asked on the install page on first run. To enable auto configuration, set your database connection via the following environment variables. ONLY use one database type!

## Official Nextcloud environment variables
For a list of environment variables for the official Nextcloud docker image please have a look at https://github.com/nextcloud/docker#auto-configuration-via-environment-variables.

## Additional environment variables
In the future this custom image will support configuration via environment variables for:
*   Cron job period
*   APCU tuning
*   OPCACHE tuning

# HTTPS - SSL encryption
There are many different possibilities to introduce encryption depending on your setup. 

I recommend using a reverse proxy in front of our Nextcloud installation using the popular [nginx-proxy](https://github.com/jwilder/nginx-proxy) and [docker-letsencrypt-nginx-proxy-companion](https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion) containers. Please check the according documentations before using this setup.
