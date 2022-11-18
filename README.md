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
    export ACR_NAME=mslacr
    export REGISTRY=${ACR_NAME}.azurecr.io
    export REPONAME=helloworld
    export REPO=${REGISTRY}/${REPONAME}
    export NOTATION_CERT_PATH="/home/vscode/.config/notation/localkeys/$REGISTRY.crt"  
    export NOTATION_USERNAME=00000000-0000-0000-0000-000000000000
    ```
4. Login so ORAS and Notation can use the auth token
    ```
    az login
    <!-- make sure you are using the correct subscription -->
    az account set -s <subscription>    
    ```

5. Get token and run available samples which will build/push all artifacts to your Azure Container Registry
    ```
    ./generate-all-artifacts.sh
    ```

## Running samples ad hoc
1. Execute steps 1-4 in the 'Get up and running' section
2. Run a single sample (example ./runner sample5)
    ```    
    ./runner <sample-dir-name>
    ```
