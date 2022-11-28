#!/bin/bash

# set up the tokens for oras and notation
notation cert remove $REGISTRY
notation key remove $REGISTRY
~/notation cert remove notationv09
~/notation key remove notationv09

# remove all local certs
rm $NOTATION_PATH_ROOT/localkeys/$REGISTRY.crt
rm $NOTATION_PATH_ROOT/localkeys/$REGISTRY.key

rm $NOTATION_PATH_ROOT/key/notationv09.key
rm $NOTATION_PATH_ROOT/certificate/notationv09.crt

# add cert to verification list
notation cert generate-test --trust $REGISTRY
~/notation cert generate-test --trust --name notationv09 $REGISTRY