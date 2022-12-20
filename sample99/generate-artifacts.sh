#!/bin/bash

# All in one image:signed, sbom:signed, vulnerability:signed

# set up vars
export IMAGE=${REPO}:all.in.one

# build image
docker build -t $IMAGE .

# push image to registry
docker push $IMAGE

# sign image
notation sign $IMAGE@$(docker manifest inspect $IMAGE -v | jq -r '.Descriptor.digest') -k $REGISTRY

# generate sbom
sbom-tool generate -b ./assets -bc ./src/myapp -pn ${REPONAME} -m ./sboms -pv 1.0 -ps acme -nsu ${REPONAME} -nsb https://${REGISTRY} -D true -V

# attach sbom
oras attach --artifact-type $SBOM_ARTIFACT_TYPE $IMAGE ./sboms/_manifest/spdx_2.2/manifest.spdx.json:$SBOM_SPDX_MEDIA_TYPE

# sign sbom
notation sign $IMAGE@$(oras discover -o json --artifact-type $SBOM_ARTIFACT_TYPE $IMAGE | jq -r ".manifests[0].digest") -k $REGISTRY

# trivy scan the image
trivy image --format sarif --output ./trivy-scans/trivy-scan.sarif $IMAGE

# attach scan results
oras attach --artifact-type $TRIVY_ARTIFACT_TYPE $IMAGE ./trivy-scans/trivy-scan.sarif:$TRIVY_SARIF_MEDIA_TYPE

# sign scan results
notation sign $IMAGE@$(oras discover -o json --artifact-type $TRIVY_ARTIFACT_TYPE $IMAGE | jq -r ".manifests[0].digest") -k $REGISTRY

# discover the image to show the tree in the console
oras discover $IMAGE -o tree

