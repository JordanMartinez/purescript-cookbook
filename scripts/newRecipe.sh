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

# Disable echo of all following script commands.
# We used to be able to echo the substitution one-liner,
# but the portable version is now too verbose.
set +x

# Replace all usages of the original recipe's name with the new recipe's name
echo "+ Substituting all occurrences of $orig in recipes/$1"
for file in $(grep -rl $orig recipes/$1)
do
    sed "s/$orig/$1/g" $file > $file.new
    mv $file.new $file
done
# This used to be as simple as:
#   grep -rl $orig recipes/$1 | xargs sed -i "s/$orig/$1/g"
# But there are portability issues with in-place substitution (-i)
# between the GNU (most linux distros) and BSD (mac osx) versions of `sed`.
# See https://stackoverflow.com/a/21243111 for details.

# ====== Additional instructions =======

echo # linebreak
echo --- Some helpful development commands for this recipe: ---

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

--------- Common to all recipe types: ---------

* Manual rebuild:
    make $1-build

* Regenerate recipe table (run this after editing recipes/$1/README.md):
    make readme
CMD
