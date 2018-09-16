#!/bin/bash

# Get Nextcloud version from official Docker image
docker images

export $(docker inspect --format='{{range .Config.Env}}{{println .}}{{end}}' nextcloud:13-apache | grep NEXTCLOUD_VERSION)
# NEXTCLOUD_VERSION=....

# Split NEXTCLOUD_VERSION for naming the tags
version=( ${NEXTCLOUD_VERSION//./ } )
# TAG naming: version="${version[0]}.${version[1]}.${version[2]}"

# Tag and push image for each additional tag: Base-image
for tag in {"${NEXTCLOUD_VERSION}-apache","${version[0]}.${version[1]}-apache","${version[0]}-apache","${version[0]}-stable-apache","${version[0]}-production-apache","${version[0]}-stable","${version[0]}-production","${version[0]}-latest"}; do  
    docker tag docker-nextcloud-$TRAVIS_BRANCH-base $DOCKER_USERNAME/travistest:$TRAVIS_BRANCH-${tag}
    docker push $DOCKER_USERNAME/travistest:$TRAVIS_BRANCH-${tag}
done

# Tag and push image for each additional tag: Preview-image
for tag in {"${NEXTCLOUD_VERSION}-apache-preview","${version[0]}.${version[1]}-apache-preview","${version[0]}-apache-preview"}; do  
    docker tag docker-nextcloud-$TRAVIS_BRANCH-preview $DOCKER_USERNAME/travistest:$TRAVIS_BRANCH-${tag}
    docker push $DOCKER_USERNAME/travistest:$TRAVIS_BRANCH-${tag}
done
