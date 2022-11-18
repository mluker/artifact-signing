#!/bin/bash

source get-token.sh
for subdir in ./sample*; do
  cd "$subdir"
  mkdir sboms
  ./generate-artifacts.sh
  cd ..
done