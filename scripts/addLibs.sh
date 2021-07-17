#!/usr/bin/env bash

# Expected usage:
# ./scripts/addLibs.sh recipes/RecipeName package1 package2 ... packageN
DIR=$1
LIBRARIES=${@:2}

set -eo xtrace

pushd $DIR
spago install $LIBRARIES
rm -rf .spago
popd
