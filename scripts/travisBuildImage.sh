#!/bin/bash

set -ev

#   Login to Docker Hub
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin

#   Build image from Dockerfile in ./apache/$2
docker build -f ./apache/$2/Dockerfile -t $1-$TRAVIS_BRANCH-$2 ./apache/$2

# Tag and push image for each additional tag
for tag in {"${NEXTCLOUD_VERSION}-apache-$2","${version[0]}.${version[1]}-apache-$2","${version[0]}-apache-$2"}; do  
    docker tag $1-$TRAVIS_BRANCH-$2 $DOCKER_USERNAME/$1:$TRAVIS_BRANCH-${tag}
    docker push $DOCKER_USERNAME/$1:$TRAVIS_BRANCH-${tag}
done
