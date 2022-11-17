# Playground for working with signing
A playground for working with:
* Notation (notaryv2)
* SBOMS (sbom-tool)
* ORAS

## Get up and running:
1. An existing ACR (update the export ACR_NAME to the name of it)
2. Launch devcontainer via codespaces
3. Export the following ENV vars
    ```
    export ACR_NAME=mslacr
    export REGISTRY=${ACR_NAME}.azurecr.io
    export REPONAME=helloworld
    export REPO=${REGISTRY}/${REPONAME}
    export NOTATION_CERT_PATH="/home/vscode/.config/notation/localkeys/$REGISTRY.crt"  
    export NOTATION_USERNAME=00000000-0000-0000-0000-000000000000
    ```
4. Login to Docker so ORAS and Notation can use the auth token
    ```
    az login
    <!-- make sure you are using the correct subscription -->
    az account set -s <subscription>    
    ```

5. Get token and build/push all artifacts to your azure container registry
    ```
    ./generate-all-artifacts.sh
    ```