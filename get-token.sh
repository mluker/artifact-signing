#!/bin/bash

# set up the tokens for oras and notation
token=$(az acr login -n $ACR_NAME --expose-token | jq -r .accessToken)
docker login $REGISTRY -u 00000000-0000-0000-0000-000000000000 -p $token
export NOTATION_PASSWORD=$token