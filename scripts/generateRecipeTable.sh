#!/usr/bin/env bash

# Output the unchanging part of the ReadMe first
cat scripts/ReadmeContent.md
echo

# Then output the Recipe ToC
echo "## Recipes"
echo
echo "| Node | Web Browser | Recipe | Description |"
echo "| :-: | :-: | - | - |"
for d in recipes/*; do
  base=$(basename $d)
  description=$(sed '3q;d' $d/README.md)
  node=" "
  if [ -f $d/nodeSupported.md ] || [ -f $d/nodeSupportedSkipCI.md ]; then
    node=":heavy_check_mark:"
  fi
  browser=" "
  if [ -d $d/web ]; then
    browser=":heavy_check_mark: ([try](https://try.ps.ai/?github=JordanMartinez/purescript-cookbook/master/recipes/$base/src/Main.purs))"
  fi
  echo "| $node | $browser | [$base]($d) | $description |"
done
