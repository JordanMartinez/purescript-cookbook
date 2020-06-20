# ===== Makefile Configuration =====

# Favor local npm devDependencies if they are installed
export PATH := node_modules/.bin:$(PATH)

# Use the `>` character rather than tabs for indentation
ifeq ($(origin .RECIPEPREFIX), undefined)
  $(error This Make does not support .RECIPEPREFIX. Please use GNU Make 4.0 or later)
endif
.RECIPEPREFIX = >

# Use one shell to run all commands in a given target rather than using
# the default setting of running each command in a separate shell
.ONESHELL:

# Make's default shell is `sh`. Setting this to `bash` enables
# the shell flags below to work.
SHELL := bash

# set -e = bash immediately exits if any command has a non-zero exit status.
# set -u = a reference to any shell variable you haven't previously
#    defined -- with the exceptions of $* and $@ -- is an error, and causes
#    the program to immediately exit with non-zero code.
# set -o pipefail = the first non-zero exit code emitted in one part of a
#    pipeline (e.g. `cat file.txt | grep 'foo'`) will be used as the exit
#    code for the entire pipeline. If all exit codes of a pipeline are zero,
#    the pipeline will emit an exit code of 0.
.SHELLFLAGS := -eu -o pipefail -c

# Emits a warning if you are referring to Make variables that don’t exist.
MAKEFLAGS += --warn-undefined-variables

# Removes a large number of built-in rules. Remove "magic" and only do
#    what we tell Make to do.
MAKEFLAGS += --no-builtin-rules

# ===== Makefile - Repo Commands =====

# Variables get that a list of all recipes that can be run on
# Node.js or browser backends
#
#   wildcard = expand globs and add a space in-between each one
#   patsubst = patsubst(textToFind,replaceItWithThisText,originalText)
targetsNodeWithCI := $(patsubst recipes/%/nodeSupported.md,%-node,$(wildcard recipes/*/nodeSupported.md))
targetsNodeSkipCI := $(patsubst recipes/%/nodeSupportedSkipCI.md,%-node,$(wildcard recipes/*/nodeSupportedSkipCI.md))
targetsNode := $(targetsNodeWithCI) $(targetsNodeSkipCI)
targetsWeb := $(patsubst recipes/%/web,%-web,$(wildcard recipes/*/web))

# Note: usages of `.PHONY: <target>` mean the target name is not an actual file
# .PHONY: targetName

# Prints all the recipes one could run via make and clarifying text.
# For now, we assume that each recipe has a `node` and `web` command,
# but not all of these will work.
.PHONY: list
list:
> @echo Use \"make RecipeName-target\" to run a recipe
> @echo
> @echo === Node Recipes ===
> @echo $(foreach t,$(targetsNode),make_$(t)) | tr ' ' '\n' | tr '_' ' '
> @echo
> @echo === Web Recipes ===
> @echo $(foreach t,$(targetsWeb),make_$(t)) | tr ' ' '\n' | tr '_' ' '

# Regenerate the ReadMe and its Recipe ToC using the current list of recipes
.PHONY: readme
readme:
> @echo Recreating the repo\'s README.md file...
> ./scripts/generateRecipeTable.sh > README.md
> @echo Done!

# Prints version and path information.
# For troubleshooting version mismatches.
.PHONY: info
info:
> which purs
> purs --version
> which spago
> spago version
> which parcel
> parcel --version

# ===== Makefile - Recipe-related Commands =====

# Tests if recipe actually exists.
recipes/%:
> @if [ ! -d $* ]
> then
>   echo
>   echo Recipe $* does not exist
>   echo
>   exit 1
> fi

# Variables shared across most targets
recipes := $(shell ls recipes)

# Functions shared across most targets that help generate paths
main = $1.Main
recipeDir = recipes/$1
recipeSpago = $(call recipeDir,$1)/spago.dhall

# Functions for Node.js-comptabile recipes that help generate paths
nodeCompat = $(call recipeDir,$1)/nodeSupported.md

# Tests whether recipe can be run on Node.js backend
recipes/%/nodeSupported.md:
> @if [ ! -f $(call nodeCompat,$*) ]
> then
>   echo
>   echo Recipe $* is not compatible with Node.js backend
>   echo
>   exit 1
> fi

# Runs recipe as node.js console app
%-node: $(call recipeDir,%) $(call nodeCompat,%)
> spago -x $(call recipeSpago,$*) run --main $(call main,$*)

# Functions for browser-comptabile recipes that help generate paths

webDir = $(call recipeDir,$1)/web
webHtml = $(call webDir,$1)/index.html
webDistDir = $(call recipeDir,$1)/web-dist

prodDir = $(call recipeDir,$1)/prod
prodHtml = $(call prodDir,$1)/index.html
prodJs = $(call prodDir,$1)/index.js
prodDistDir = $(call recipeDir,$1)/prod-dist

# Builds a single recipe. A build is necessary before parcel commands.
%-build:
> spago -x $(call recipeSpago,$*) build

# Tests whether recipe can be run on web browser backend
recipes/%/web:
> @if [ ! -d $(call webDir,$*) ]
> then
>   echo
>   echo Recipe $* is not compatible with the web browser backend
>   echo
>   exit 1
> fi

# Launches recipe in web browser
%-web: $(call recipeDir,%) $(call webDir,%) %-build
> parcel $(call webHtml,$*) --out-dir $(call webDistDir,$*) --open

# Uses parcel to quickly create an unminified build.
# For CI purposes.
%-buildWeb: export NODE_ENV=development
%-buildWeb: $(call recipeDir,%) $(call webDir,%) %-build
> parcel build $(call webHtml,$*) --out-dir $(call webDistDir,$*) --no-minify --no-source-maps

# Note: `%-buildProd` and its related commands were commented out
# because the command doesn't currently work.

# How to make prodDir
# recipes/%/prod:
# > mkdir -p $@

# How to make prodHtml
# recipes/%/prod/index.html: $(call prodDir,%)
# > cp $(call webHtml,$*) $(call prodDir,$*)

# Creates a minified production build.
# For reference.
# %-buildProd: $(call recipeDir,%) $(call webDir,%) $(call prodHtml,%)
# > spago -x $(call recipeSpago,$*) bundle-app --main $(call main,$*) --to $(call prodJs,$*)
# > parcel build $(call prodHtml,$*) --out-dir $(call prodDistDir,$*)

# ===== Makefile - CI Commands =====

# Runs a single recipe's CI.
%-testCI: $(call recipeDir,%)
> @if [ -f $(call nodeCompat,$*) ]
> then
>   echo Testing $* on the Node.js backend
>   spago -x $(call recipeSpago,$*) run --main $(call main,$*)
>   echo
>   echo == $* - Succeeded on Node.js
>   echo
> fi
> @if [ -d $(call webDir,$*) ]
> then
>   echo Attempting to build $* for the browser backend
>   export NODE_ENV=development
>   parcel build $(call webHtml,$*) --out-dir $(call webDistDir,$*) --no-minify --no-source-maps
>   echo
>   echo == $* - Built for browser
>   echo
> fi

targetsAllCI := $(foreach r,$(recipes),$(r)-testCI)

# Run all recipes CI
.PHONY: testAllCI
testAllCI: $(targetsAllCI)

# Verifies that running all the above commands for a single
# recipe actually works.
testAllCommands:
> $(MAKE)
> $(MAKE) HelloWorld-node
> $(MAKE) HelloWorld-build
> $(MAKE) HelloWorld-buildWeb
> $(MAKE) HelloWorld-testCI
# > $(MAKE) HelloWorld-buildProd
