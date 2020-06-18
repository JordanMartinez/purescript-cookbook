#!/usr/bin/env bash

echo "# Recipes"
echo
echo "| Recipe | Description | Node | Browser |"
echo "| - | - | - | - |"
for d in recipes/*; do
  base=$(basename $d)
  description=$(sed '3q;d' $d/README.md)
  node=" "
  if [ -f $d/nodeSupported.md ]; then
    node=":heavy_check_mark:"
  fi
  browser=" "
  if [ -d $d/dev ]; then
    browser=":heavy_check_mark:"
  fi
  echo "| [$base]($d) | $description | $node | $browser |"
done
