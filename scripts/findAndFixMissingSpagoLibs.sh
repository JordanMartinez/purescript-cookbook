#!/usr/bin/env bash

# Run this in the repo's root directory

FILE=result.txt

# Find the recipe that fails to build
make testAllCI 2>$FILE | grep '=='

# find the directory based on the make error message
DIR=$(cat $FILE | grep 'make: *** ' | cut -d ' ' -f 4 | sed 's/\]//' | sed 's/-build//' | sed 's/-prod//')

# Find the suggested command by spago on what libs to install
LIBS=$(cat $FILE | grep 'spago install ' | sed 's/spago install //')

# Install the missing packages
./scripts/addLibs.sh recipes/$DIR $LIBS
