#!/usr/bin/env bash

# Exit on first failure
set -e

print_error() {
    cat <<HELP
Error: $1

Usage:
./scripts/newRecipe.sh <new recipe name> <optional recipe to copy>

Examples:
./scripts/newRecipe.sh MyNewRecipe
./scripts/newRecipe.sh MyNewRecipe HelloHalogenHooks
./scripts/newRecipe.sh MyNewRecipe recipes/HelloHalogenHooks/
HELP
exit 1
}

# Valid number of arguments is either 1 or 2
[ $# -eq 0 ] && print_error 'No arguments'
[ $# -gt 2 ] && print_error 'Too many arguments'

# Use a default original recipe if one is not provided.
# Just take basename of recipe path.
orig=$(basename ${2:-HelloLog})

echo "Creating new recipe $1 from $orig"

# Echo all following script commands
set -x

# Copy original recipe to new recipe directory
cp -r recipes/$orig recipes/$1

# Replace all usages of the original recipe's name with the new recipe's name
grep -rl $orig recipes/$1 | xargs sed -i "s/$orig/$1/g"

# Build recipe
make $1-build


# ====== Additional instructions =======

# Disable echo of all following script commands
set +x

echo Some helpful development commands for this recipe:

# Basic node
[ -f recipes/$1/nodeSupported.md ] && cat <<CMD

* Watch for changes and rebuild and re-run in node.js:
    make $1-node-watch
CMD

# Node CLI - Watching causes issues with this
[ -f recipes/$1/nodeSupportedSkipCI.md ] && cat <<CMD

* Re-run in node.js:
    make $1-node
CMD

# Web
[ -d recipes/$1/web ] && cat <<CMD

* Launch in web browser (will refresh upon rebuild):
    make $1-web

* Watch for changes and rebuild (only necessary if editing without purs-ide):
    make $1-build-watch
CMD

# Common
cat <<CMD

* Manual Rebuild:
    make $1-build

* Regenerate recipe table (run this after editing recipes/$1/README.md):
    make readme
CMD
