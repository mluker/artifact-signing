#!/bin/bash

# Just a signed image with signed sbom

# set up vars
export IMAGE=${REPO}:signed.signed.sbom

# build image
docker build -t $IMAGE .

# push image to registry
docker push $IMAGE

# sign image
notation sign -k $REGISTRY $IMAGE

# generate sbom
sbom-tool generate -b ./assets -bc ./src/myapp -pn ${REPONAME} -m ./sboms -pv 1.0 -ps acme -nsu ${REPONAME} -nsb https://${REGISTRY} -D true -V

# attach sbom
oras attach --artifact-type $SBOM_ARTIFACT_TYPE $IMAGE ./sboms/_manifest/spdx_2.2/manifest.spdx.json:$SBOM_SPDX_MEDIA_TYPE

# sign sbom
notation sign $IMAGE@$(oras discover -o json --artifact-type $SBOM_ARTIFACT_TYPE $IMAGE | jq -r ".manifests[0].digest") -k $REGISTRY

# discover the image to show the tree in the console
oras discover $IMAGE -o tree

