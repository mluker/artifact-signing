#!/bin/bash

# Just a signed image

# set up vars
export IMAGE=${REPO}:signed

# build image
docker build -t $IMAGE .

# push image to registry
docker push $IMAGE

# create cert
notation cert generate-test --default $REGISTRY

# add cert to verification list
notation cert add -n $REGISTRY "$NOTATION_CERT_PATH"

# sign image
notation sign $IMAGE