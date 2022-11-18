# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.245.2/containers/go/.devcontainer/base.Dockerfile

# [Choice] Go version (use -bullseye variants on local arm64/Apple Silicon): 1, 1.19, 1.18, 1-bullseye, 1.19-bullseye, 1.18-bullseye, 1-buster, 1.19-buster, 1.18-buster
ARG VARIANT="1.19-bullseye"
FROM mcr.microsoft.com/vscode/devcontainers/go:0-${VARIANT}
#FROM mcr.microsoft.com/vscode/devcontainers/base:focal
#--platform=linux/amd64
# [Choice] Node.js version: none, lts/*, 18, 16, 14
ARG NODE_VERSION="none"
RUN if [ "${NODE_VERSION}" != "none" ]; then su vscode -c "umask 0002 && . /usr/local/share/nvm/nvm.sh && nvm install ${NODE_VERSION} 2>&1"; fi

ARG NOTATION_VERSION="0.11.0-alpha.4"
RUN curl -Lo notation.tar.gz https://github.com/notaryproject/notation/releases/download/v${NOTATION_VERSION}/notation_${NOTATION_VERSION}_linux_amd64.tar.gz \
    && tar -zxf notation.tar.gz \
    && mv ./notation /usr/local/bin/notation \
    && rm -rf ./notation.tar.gz
   
RUN curl -Lo notation_0.9.0-alpha.1_linux_amd64.tar.gz https://github.com/notaryproject/notation/releases/download/v0.9.0-alpha.1/notation_0.9.0-alpha.1_linux_amd64.tar.gz \
    && mkdir -p notation-old-install \
    && tar -zxf notation_0.9.0-alpha.1_linux_amd64.tar.gz -C notation-old-install \
    && mv ./notation-old-install/* ~/ \
    && rm -rf ./notation_0.9.0-alpha.1_linux_amd64.tar.gz

ARG ORAS_VERSION="0.15.0"
RUN curl -LO https://github.com/oras-project/oras/releases/download/v0.15.0/oras_${ORAS_VERSION}_linux_amd64.tar.gz \
    && mkdir -p oras-install \
    && tar -zxf oras_0.15.0_*.tar.gz -C oras-install \
    && mv oras-install/oras /usr/local/bin/

RUN curl -Lo sbom-tool https://github.com/microsoft/sbom-tool/releases/latest/download/sbom-tool-linux-x64 \
    && chmod +x sbom-tool \
    && mv sbom-tool /usr/local/bin/

# [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends protobuf-compiler libprotobuf-dev

# [Optional] Uncomment the next lines to use go get to install anything else you need
USER vscode
# RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.28 \
#     && go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.2

# [Optional] Uncomment this line to install global node packages.
# RUN su vscode -c "source /usr/local/share/nvm/nvm.sh && npm install -g <your-package-here>" 2>&1