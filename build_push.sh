#!/bin/bash

SOURCE_BRANCH="master"
SOURCE_COMMIT=`git ls-remote https://github.com/AlexeyAB/darknet.git HEAD | awk '{ print $1 }'`
DOCKER_REPO="mpecic/darknet"
DOCKER_TAG="gpu-cv-cc86"

echo $DOCKER_REPO
echo $DOCKER_TAG
echo $SOURCE_BRANCH
echo $SOURCE_COMMIT

echo "building gpu-cv"
docker build \
  --build-arg SOURCE_BRANCH=$SOURCE_BRANCH \
  --build-arg SOURCE_COMMIT=$SOURCE_COMMIT \
  -t $DOCKER_REPO:$DOCKER_TAG .

docker push $DOCKER_REPO:$DOCKER_TAG
