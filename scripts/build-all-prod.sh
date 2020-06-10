#!/usr/bin/env bash

for d in recipes/*; do
  if [ -d $d/dev ]; then
    npm run build-prod --cookbook:recipe=$(basename $d)
  fi
done
