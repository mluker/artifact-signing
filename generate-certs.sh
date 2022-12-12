#!/bin/bash

# notation directory structure
# @mluker ➜ ~/.config/notation $ tree
# .
# ├── certificate
# │   └── notationv09.crt
# ├── config.json
# ├── key
# │   └── notationv09.key
# ├── localkeys
# │   ├── <acr-name>.azurecr.io.crt
# │   └── <acr-name>.azurecr.io.key
# ├── signingkeys.json
# └── truststore
#     └── x509
#         └── ca
#             └── <acr-name>.azurecr.io
#                 └── <acr-name>.azurecr.io.crt
#

# set up the tokens for oras and notation
notation cert delete -y -t ca -s $REGISTRY $REGISTRY.crt
notation cert delete -y -t ca -s certs $REGISTRY.crt

notation key delete $REGISTRY
~/notation cert remove notationv09
~/notation key remove notationv09

# remove all local certs
rm $NOTATION_PATH_ROOT/localkeys/$REGISTRY.crt
rm $NOTATION_PATH_ROOT/localkeys/$REGISTRY.key

# empty trust store
rm $NOTATION_PATH_ROOT/key/notationv09.key
rm $NOTATION_PATH_ROOT/certificate/notationv09.crt

# add cert to verification list, this will automatically add the test cert to a store named the same as the registry
notation cert generate-test $REGISTRY

# add the created test cert to the trust store named 'certs' folder and remove the original one
notation cert add --type ca --store certs $NOTATION_PATH_ROOT/truststore/x509/ca/$REGISTRY/$REGISTRY.crt
rm -rf $NOTATION_PATH_ROOT/truststore/x509/ca/$REGISTRY

~/notation cert generate-test --trust --name notationv09 $REGISTRY