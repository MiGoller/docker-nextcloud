# About this custom image for Nextcloud
Here you find custom Docker images for [Nextcloud](https://nextcloud.com/) based on the [official Apache Docker image for Nextcloud](https://hub.docker.com/_/nextcloud/). Many thanks to the [Nextcloud](https://nextcloud.com/) devs for their great work!

# What is Nextcloud?
A safe home for all your data. Access & share your files, calendars, contacts, mail & more from any device, on your terms.

![logo](https://cdn.rawgit.com/nextcloud/docker/57b5e03f2abe51f81aa9a5c80018d10b5ed1c353/logo.svg)

# Supported tags
Right now the Apache based tags for the Nextcloud Docker image are supported.

The `apache` tag contains an essential Nextcloud installation including an apache web server. It is designed to be easy to use and get's you running pretty fast. This is also the default for the `latest` tag and version tags that are not further specified.

You have to choose between the different flavours:
*   `apache` extends the [official Apache Docker image for Nextcloud](https://hub.docker.com/_/nextcloud/) by the recommended PHP-settings and the recommended cron-job running Nextcloud's ```cron.php``` every 15 minutes.
*   `imap` adds IMAP-authentication capabilities to my `apache` images.
*   `smb` adds SAMBA-authentication capabilities to my `apache` images.
*   `preview` adds imagik-based file preview capabilities to my `apache` images for pictures and videos. Libre Office is not included.
*   `full` extends my `apache` images with all capabilities from the `imap`, `smb` and `preview` flavours.

# How to use this image
This image is designed to run in a micro-service environment.

I encourage you to create volumes or to mount local folders for Nextcloud's data, configuration and apps. Otherwise you will loose your data and configuration when removing the container.

If you are interested in how to run Docker containers using `docker-compose` or `docker run ...` and `systemd`, pleas have a look at https://github.com/MiGoller/dc-systemd-template .

## Simply dock Nextcloud with docker run
The apache image contains a webserver and exposes port 80. To start the container type:
```console
$ docker run -d -p 8080:80 migoller/nextcloud
```

Now you can access Nextcloud at http://localhost:8080/ from your host system, but you need access to an existing MySQL server.

You may mount volumes and set environment variables on the command line.
```console
$ docker run -it --name <container_name> \
       --link <your_MySql_containter>:db_nextcloud \
       -v <local_path_to_nextcloud_storage_folder>:/var/www/html/data \
       -v <local_path_to_nextcloud_config_folder>/config:/var/www/html/config \
       -v <local_path_to_nextcloud_config_folder>/apps:/var/www/html/custom_apps \
       -e NEXTCLOUD_ADMIN_USER=<your_nextcloud_admin_username> \
       -e NEXTCLOUD_ADMIN_PASSWORD=<your_nextcloud_admin_password> \
       -e MYSQL_DATABASE=<your_MySql_database_name> \
       -e MYSQL_USER=<your_MySql_username> \
       -e MYSQL_PASSWORD=<your_MySql_password> \
       -e MYSQL_HOST=db_nextcloud \
       -p 8080:80 \
       migoller/nextcloud
```

## Compose your own Nextcloud stack
As mentioned before the `apache` images contain an Apache webserver, but they do not inclunde an DBMS like MySQL or MariaDB. You can easily create, deploy and run your own Nextcloud stack with docker compose.

The `docker-compose cli` can be used to manage a multi-container application. It also moves many of the options you would enter on the `docker run cli` into the `docker-compose.yml` file for easier reuse. See this [documentation on docker-compose](https://docs.docker.com/compose/overview/) for more details.

Declare environment variables in `env-files` for easier reuse.

Have a look at the [docker-compose example](../../examples/docker-compose) for further details and the example files. Ensure to provide different passwords to your containers!

### Create a docker-compose.yml to fit your needs
First you will have to create a docker-compose.yml to match your local requirements. You may start with one of the example files and modify it.
```yaml
version: '2'
services:
  db:
    image: mysql
    env_file:
      - MySQL.env
    volumes:
      - ./datadir:/var/lib/mysql
  app:
    image: migoller/nextcloud:apache
    env_file:
      - MySQL.env
      - Nextcloud.env
    volumes:
      - ./data:/var/www/html/data
      - ./config:/var/www/html/config
      - ./apps:/var/www/html/custom_apps
    depends_on:
      - db
    ports:
      - "8080:80"
```
Adjust the volumes' local pathes to fit your local system. Environment variables are defined at the env-files; so we're able to define them once and to use them within both containers at runtime.

### Start you Nextcloud stack powered by docker-compose
To start our stack you will just have to issue the following command in the path where the `docker-compose.yml` exists.
```console
$ docker-compose up -d
```

### Stop your docker-compose powered stack
Well that's as easy as to start the stack.
```console
$ docker-compose down
```

# Adding Features
A lot of people want to use additional functionality inside their Nextcloud installation. If the image does not include the packages you need, you can easily build your own image on top of it.
Start your derived image with the `FROM` statement and add whatever you like.

```yaml
FROM migoller/nextcloud

RUN ...

```
The [examples folder](https://github.com/nextcloud/docker/blob/master/.examples) gives a few examples on how to add certain functionalities, like including the cron job, smb-support or imap-authentication. 

For further details please have a look at [Nextcloud full image Dockerfile](https://github.com/nextcloud/docker/blob/master/.examples/dockerfiles/full/apache/Dockerfile).

# Auto configuration via environment variables
The nextcloud image supports auto configuration via environment variables. You can preconfigure everything that is asked on the install page on first run. To enable auto configuration, set your database connection via the following environment variables. ONLY use one database type!

## Official Nextcloud environment variables
For a list of environment variables for the official Nextcloud docker image please have a look at https://github.com/nextcloud/docker#auto-configuration-via-environment-variables.

### Nextcloud administrator
* `NEXTCLOUD_ADMIN_USER` sets the username for your Nextcloud's administrator account.
* `NEXTCLOUD_ADMIN_PASSWORD` should be set to a really complex password for your Nextcloud's administrator account.

### MySQL configuration
* `MYSQL_USER` sets the MySQL username for runtime access to the database.
* `MYSQL_PASSWORD` should be set to a complex password for the `MYSQL_USER` account.
* `MYSQL_HOST` sets the hostname of the remote MySQL server.
* `MYSQL_DATABASE` sets Nextcloud's database name.
* `MYSQL_ROOT_USER` sets the username of your MySQL servers root user account. In most cases this setting will remain "root".
* `MYSQL_ROOT_PASSWORD` sets the password for the MySQL.

## Additional environment variables
In the future this custom image will support configuration via environment variables for:
*   Cron job period
*   APCU tuning
*   OPCACHE tuning

# HTTPS - SSL encryption
There are many different possibilities to introduce encryption depending on your setup. 

I recommend using a reverse proxy in front of our Nextcloud installation using the popular [nginx-proxy](https://github.com/jwilder/nginx-proxy) and [docker-letsencrypt-nginx-proxy-companion](https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion) containers. Please check the according documentations before using this setup.
