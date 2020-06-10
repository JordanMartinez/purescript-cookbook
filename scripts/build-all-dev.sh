#!/usr/bin/env bash

for d in recipes/*; do
  if [ -d $d/dev ]; then
    npm run build-dev --cookbook:recipe=$(basename $d)
  fi
done
