#!/bin/bash

# Get Nextcloud version from official Docker image
docker images

export $(docker inspect --format='{{range .Config.Env}}{{println .}}{{end}}' nextcloud:13-apache | grep NEXTCLOUD_VERSION)
# NEXTCLOUD_VERSION=....

# Split NEXTCLOUD_VERSION for naming the tags
version=( ${NEXTCLOUD_VERSION//./ } )
# TAG naming: version="${version[0]}.${version[1]}.${version[2]}"

# Tag and push image for each additional tag
for tag in {"${NEXTCLOUD_VERSION}-apache","${version[0]}.${version[1]}-apache","${version[0]}-apache","${version[0]}-stable-apache","${version[0]}-production-apache","${version[0]}-stable","${version[0]}-production","${version[0]}-latest"}; do  
    docker tag docker-nextcloud-stage $DOCKER_USERNAME/travistest:${tag}
    docker push $DOCKER_USERNAME/travistest:${tag}
done
