#!/usr/bin/env bash

# Output the unchanging part of the ReadMe first
cat scripts/ReadmeContent.md
echo

# Then output the Recipe ToC
echo "## Recipes"
echo
echo "| Node | Browser | Recipe | Description |"
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
  echo "| $node | $browser | [$base]($d) | $description |"
done
