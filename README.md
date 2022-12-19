# Playground for working with signing
A playground for working with:
* Notation (notaryv2)
* SBOMS (sbom-tool)
* ORAS
* Trivy

## Sample overview
* Sample1: Unsigned image
* Sample2: Signed image
* Sample3: Signed image with sbom
* Sample4: Signed image with signed sbom
* Sample5: Signed image using notation v0.9

## How to get up and running
1. You must have an existing ACR (update the 'ACR_NAME' below to the name of your ACR)
2. Launch the devcontainer via codespaces
3. Export the following ENV vars
    ```
    export ACR_NAME=mslacr
    export REGISTRY=${ACR_NAME}.azurecr.io
    export REPONAME=helloworld
    export REPO=${REGISTRY}/${REPONAME}
    export NOTATION_PATH_ROOT="/home/vscode/.config/notation"
    export NOTATION_USERNAME=00000000-0000-0000-0000-000000000000
    export SBOM_ARTIFACT_TYPE=org.example.sbom.v0
    export SBOM_SPDX_MEDIA_TYPE=application/spdx+json
    export TRIVY_ARTIFACT_TYPE=vnd.aquasecurity.trivy.report.sarif.v1
    export TRIVY_SARIF_MEDIA_TYPE=application/sarif+json
    ```
4. Login so ORAS and Notation can use the auth token
    ```
    az login
    <!-- make sure you are using the correct subscription -->
    az account set -s <subscription>
    ```
5. Generate new certs for all of the notation tasks to use.
    This will delete the certs from ~/.config/notation/localkeys|keys|certificate and remove them from notations key store. It will then generate new certs and add them all back to notations store.

    Note: You will have to do this every day as the notation test certs are only valid for 1 day.
    ```
    ./generate-certs.sh
    ```

6. Get token and run available samples which will build/push all artifacts to your Azure Container Registry
    ```
    ./generate-all-artifacts.sh
    ```

## Running samples ad hoc
1. Execute steps 1-4 in the 'Get up and running' section
2. Run a single sample (example ./runner sample5)
    ```
    ./runner <sample-dir-name>
    ```

## Working with artifacts

### Discover all referrers of a manifest

```sh
oras discover -o tree mslacr.azurecr.io/helloworld:signed.signed.sbom
```
or use the digest

```sh
oras discover -o tree mslacr.azurecr.io/helloworld@sha256:0c4ac66a03fa244923611a3136e6bdec32a7e7d10bbcba0dc505e89f0dbc0f01
```

Output:
```sh
mslacr.azurecr.io/helloworld@sha256:0c4ac66a03fa244923611a3136e6bdec32a7e7d10bbcba0dc505e89f0dbc0f01
├── org.example.sbom.v0
│   └── sha256:2fbaacd7c9696da728325756f773cbf42b1c2f6bcd0902d8c735c0f2e4c977bd
│       └── application/vnd.cncf.notary.signature
│           └── sha256:0af57cbaee9355c79245f998d2ad04eb5e558310784e5b30e83a51b7019da583
└── application/vnd.cncf.notary.signature
    └── sha256:54c1db986593115880d709e7906d0d71d09bbbfdcc2c1bd75ef45357be7a5f52

```

### Discover referrers of a digest manifest

JSON Output:

```sh
oras discover -o json mslacr.azurecr.io/helloworld@sha256:2fbaacd7c9696da728325756f773cbf42b1c2f6bcd0902d8c735c0f2e4c977bd
```

```json
{
    "mediaType": "application/vnd.oci.artifact.manifest.v1+json",
    "artifactType": "org.example.sbom.v0",
    "blobs": [
        {
            "mediaType": "application/spdx+json",
            "digest": "sha256:ca282fef4d56a2bcb91a97a2263a01ee0abf7d05a1a970b12b077e15e70f5c56",
            "size": 3191,
            "annotations": {
                "org.opencontainers.image.title": "sboms/_manifest/spdx_2.2/manifest.spdx.json"
            }
        }
    ],
    "subject": {
        "mediaType": "application/vnd.docker.distribution.manifest.v2+json",
        "digest": "sha256:0c4ac66a03fa244923611a3136e6bdec32a7e7d10bbcba0dc505e89f0dbc0f01",
        "size": 1152
    },
    "annotations": {
        "org.opencontainers.artifact.created": "2022-12-12T15:14:27Z"
    }
}
```

Tree output:

```sh
oras discover -o tree mslacr.azurecr.io/helloworld@sha256:2fbaacd7c9696da728325756f773cbf42b1c2f6bcd0902d8c735c0f2e4c977bd
```

```sh
mslacr.azurecr.io/helloworld@sha256:2fbaacd7c9696da728325756f773cbf42b1c2f6bcd0902d8c735c0f2e4c977bd
└── application/vnd.cncf.notary.signature
    └── sha256:0af57cbaee9355c79245f998d2ad04eb5e558310784e5b30e83a51b7019da583
```

Get the actual SBOM (blob) file:

```sh
oras blob fetch -o sbom_contents.json mslacr.azurecr.io/helloworld@sha256:ca282fef4d56a2bcb91a97a2263a01ee0abf7d05a1a970b12b077e15e70f5c56
```

Output (sbom_contents.json):
```json
{
  "files": [
    {
      "fileName": "./files/stuff/bird.txt",
      "SPDXID": "SPDXRef-File--files-stuff-bird.txt-DA39A3EE5E6B4B0D3255BFEF95601890AFD80709",
      "checksums": [
        {
          "algorithm": "SHA256",
          "checksumValue": "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
        },
        {
          "algorithm": "SHA1",
          "checksumValue": "da39a3ee5e6b4b0d3255bfef95601890afd80709"
        }
      ],
      "licenseConcluded": "NOASSERTION",
      "licenseInfoInFiles": [
        "NOASSERTION"
      ],
      "copyrightText": "NOASSERTION"
    }    
    ..... truncated
```