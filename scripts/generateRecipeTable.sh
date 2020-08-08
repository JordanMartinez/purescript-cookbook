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

  # Grab third line of readme as description
  description=$(sed '3q;d' $d/README.md)

  # Check if node is supported
  node=" "
  if [ -f $d/nodeSupported.md ] || [ -f $d/nodeSupportedSkipCI.md ]; then
    node=":heavy_check_mark:"
  fi

  # Check if web browser is supported
  browser=" "
  if [ -d $d/web ]; then
    browser=":heavy_check_mark:"

    # Check if Try PureScript is supported (not unsupported)
    if [ ! -f $d/tryUnsupported.md ]; then
      tryLink="[try](https://try.ps.ai/?github=JordanMartinez/purescript-cookbook/master/recipes/$base/src/Main.purs)"

      # Check if the recipe needs to be fixed for TPS
      if [ -f $d/tryFixMe.md ]; then
        tryLink="$tryLink - [fixme]($d/tryFixMe.md)"
      fi

      browser="$browser ($tryLink)"
    fi
  fi
  # Render table row for recipe
  echo "| $node | $browser | [$base]($d) | $description |"
done
