#!/bin/bash

source get-token.sh
echo $NOTATION_PASSWORD

for subdir in ./sample*; do
  cd "$subdir"
  mkdir sboms
  ./generate-artifacts.sh
  cd ..
done