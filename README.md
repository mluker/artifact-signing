# Playground for working with signing
A playground for working with:
* Notation (notaryv2)
* SBOMS (sbom-tool)
* ORAS

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
    export ACR_NAME=samplelacr
    export REGISTRY=${ACR_NAME}.azurecr.io
    export REPONAME=helloworld
    export REPO=${REGISTRY}/${REPONAME}
    #export NOTATION_PATH_ROOT="/home/vscode/.config/notation/truststore/x509/ca"
    export NOTATION_PATH_ROOT="/home/vscode/.config/notation"
    export NOTATION_USERNAME=00000000-0000-0000-0000-000000000000
    export SBOM_ARTIFACT_TYPE=application/spdx+json
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