#!/bin/bash

# Just a signed image

# set up vars
export IMAGE=${REPO}:signed

# build image
docker build -t $IMAGE .

# push image to registry
docker push $IMAGE

# sign image
notation sign $IMAGE -k $REGISTRY