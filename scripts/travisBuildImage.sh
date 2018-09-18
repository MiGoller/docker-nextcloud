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

#   Special tags to set?
if [ ! -z "$3" ]
then
    SPECIAL_TAGS = $3
    echo "Appying special tags to that image: $SPECIAL_TAGS."
    # Split NEXTCLOUD_VERSION for naming the tags
    MY_TAGS=( ${SPECIAL_TAGS//,/ } )
    for tag in "${MY_TAGS[@]}"; do
        for to_tag in {"${version[0]}-${MY_TAG}","${version[0]}-${MY_TAG}$TAG_SUFFIX"}; do
            echo "--> Tagging docker image with special tag: $DOCKER_USERNAME/$1:${to_tag}"
            docker tag $1-$TRAVIS_BRANCH-$2 $DOCKER_USERNAME/$1:${to_tag}
            docker push $DOCKER_USERNAME/$1:${to_tag}
        done
    done
fi
