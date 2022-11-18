#!/bin/bash

# Just a signed image using notation v0.9

# set up vars
export IMAGE=${REPO}:signed.notation.v0.9

# build image
docker build -t $IMAGE .

# push image to registry
docker push $IMAGE

# create cert
~/notation cert generate-test --trust --name notationv09 --default $REGISTRY

# sign image
~/notation sign $IMAGE