#!/bin/bash

# Just a signed image with signed sbom

# set up vars
export IMAGE=${REPO}:signed.signed.sbom

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

# generate sbom
sbom-tool generate -b ./assets -bc ./src/myapp -pn ${REPONAME} -m ./sboms -pv 1.0 -ps acme -nsu ${REPONAME} -nsb https://${REGISTRY} -D true -V

# attach sbom
oras attach --artifact-type ${REGISTRY}.sbom.v0 $IMAGE ./sboms/_manifest/spdx_2.2/manifest.spdx.json

# sign sbom
notation sign $IMAGE@$(oras discover -o json --artifact-type ${REGISTRY}.sbom.v0 $IMAGE | jq -r ".referrers[0].digest")




