#!/bin/bash

source get-token.sh

if [ -z $1 ]; then  
  echo "Specify sample file name as parameter (i.e. sample5)"
  exit
fi

if [ ! -d ./$1 ]; then  
  echo "There is no sample folder $1"
  exit
fi

cd "$1"
mkdir sboms
./generate-artifacts.sh
cd ..