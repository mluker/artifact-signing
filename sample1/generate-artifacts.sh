#!/bin/bash

# Just an image

# set up vars
export IMAGE=${REPO}:unsigned

# build image
docker build -t $IMAGE .

# push image to registry
docker push $IMAGE