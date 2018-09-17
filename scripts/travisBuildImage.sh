#!/bin/bash

set -ev

#   Login to Docker Hub
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin

#   Build image from Dockerfile in ./apache/$2
docker build -f ./apache/$2/Dockerfile -t $1-$TRAVIS_BRANCH-$2 ./apache/$2

#   Get Nextcloud version information from image
docker images

export $(docker inspect --format='{{range .Config.Env}}{{println .}}{{end}}' $1-$TRAVIS_BRANCH-$2 | grep NEXTCLOUD_VERSION)

# Split NEXTCLOUD_VERSION for naming the tags
version=( ${NEXTCLOUD_VERSION//./ } )

#   Define tag suffix
echo "Image type: $2."
case "$2" in
 base) export TAG_SUFFIX="-apache" ;;
    *) export TAG_SUFFIX="-apache-$2" ;;
esac

# Tag and push image for each additional tag
for tag in {"${NEXTCLOUD_VERSION}","${version[0]}.${version[1]}","${version[0]}"}; do  
    echo "--> Tagging docker image: $DOCKER_USERNAME/$1:${tag}$TAG_SUFFIX"
    docker tag $1-$TRAVIS_BRANCH-$2 $DOCKER_USERNAME/$1:${tag}$TAG_SUFFIX
    docker push $DOCKER_USERNAME/$1:${tag}$TAG_SUFFIX
done
