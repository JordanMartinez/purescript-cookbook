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

# Targets for CI
targetsNodeBuildOnlyCI := $(patsubst %-node,%-build,$(targetsNodeSkipCI))
targetsWebBuildOnlyCI := $(patsubst %-web,%-buildWeb,$(targetsWeb))
targetsAllCI := $(targetsNodeWithCI) $(targetsNodeBuildOnlyCI) $(targetsWebBuildOnlyCI)

# Build everything. For editor tags.
targetsBuild := $(patsubst recipes/%/,%-build,$(wildcard recipes/*/))

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
> which npm
> npm --version

# Downloads all dependencies and sets up cookbook, so that end-user doesn't
# accidentally use `npm`.
.PHONY: installDeps
installDeps:
> npm i
> rm package-lock.json

# ===== Makefile - Recipe-related Commands =====

# Tests if recipe actually exists.
# The unused dummy lowpriority prerequisite is just to allow
# the rule for recipes/%/web/index.html to take priority over this rule.
# https://stackoverflow.com/questions/62494658/gnu-make-not-matching-shortest-stem
recipes/%: lowpriority%
> @if [ ! -d $* ]
> then
>   echo
>   echo Recipe $* does not exist
>   echo
>   exit 1
> fi

# Does nothing. See above for explanation.
lowpriority%:
	@:

# Variables shared across most targets
recipes := $(shell ls recipes)

# Functions shared across most targets that help generate paths
main = $1.Main
recipeDir = recipes/$1
recipeSpago = $(call recipeDir,$1)/spago.dhall

# Functions for Node.js-comptabile recipes that help generate paths
nodeCompat = $(call recipeDir,$1)/nodeSupported.md
nodeCompatSkipCI = $(call recipeDir,$1)/nodeSupportedSkipCI.md

# Tests whether recipe can be run on Node.js backend
.PHONY: %-nodeCompatible
%-nodeCompatible:
> @if [ ! -f $(call nodeCompat,$*) ] && [ ! -f $(call nodeCompatSkipCI,$*) ]
> then
>   echo
>   echo Recipe $* is not compatible with Node.js backend
>   echo
>   exit 1
> fi

.PHONY: %-node
# Runs recipe as node.js console app
%-node: $(call recipeDir,%) %-nodeCompatible
> @echo === Running $* on the Node.js backend ===
> spago -x $(call recipeSpago,$*) run --main $(call main,$*)

# Functions for browser-comptabile recipes that help generate paths

webDir = $(call recipeDir,$1)/web
webHtml = $(call webDir,$1)/index.html
webJs = $(call webDir,$1)/index.js
webDistDir = $(call recipeDir,$1)/web-dist

prodDir = $(call recipeDir,$1)/prod
prodHtml = $(call prodDir,$1)/index.html
prodJs = $(call prodDir,$1)/index.js
prodDistDir = $(call recipeDir,$1)/prod-dist

# Builds a single recipe. A build is necessary before parcel commands.
.PHONY: %-build
%-build:
> @echo === Building $* ===
> spago -x $(call recipeSpago,$*) build

# Tests whether recipe can be run on web browser backend
recipes/%/web:
> @echo Recipe $* is not compatible with the web browser backend
> exit 1

# Check if index.js points to another recipe.
%-indexCheck:
> @if ! grep "require(\"../../../output/$*.Main/index.js\").main();" $(call webJs,$*) --quiet
> then
>   echo Error: $(call webJs,$*) points to another recipe:
>   cat $(call webJs,$*)
>   exit 1
> fi

.PHONY: %-web
# Launches recipe in web browser
%-web: $(call recipeDir,%) $(call webDir,%) %-indexCheck %-build
> @echo === Launching $* in the web browser ===
> parcel $(call webHtml,$*) --out-dir $(call webDistDir,$*) --open

.PHONY: %-buildWeb
# Uses parcel to quickly create an unminified build.
# For CI purposes.
%-buildWeb: export NODE_ENV=development
%-buildWeb: $(call recipeDir,%) $(call webDir,%) %-indexCheck %-build
> @echo === Building $* for the web browser backend ===
> parcel build $(call webHtml,$*) --out-dir $(call webDistDir,$*) --no-minify --no-source-maps

# How to make prodDir
recipes/%/prod:
> mkdir -p $@

# How to make prodHtml
recipes/%/prod/index.html: $(call prodDir,%)
> cp $(call webHtml,$*) $(call prodDir,$*)

.PHONY: %-buildProd
# Creates a minified production build.
# For reference.
%-buildProd: $(call recipeDir,%) $(call webDir,%) $(call prodHtml,%)
> @echo === Building $* for production ===
> spago -x $(call recipeSpago,$*) bundle-app --main $(call main,$*) --to $(call prodJs,$*)
> parcel build $(call prodHtml,$*) --out-dir $(call prodDistDir,$*)

# Build everything. For editor tags.
.PHONY: buildAll
buildAll: $(targetsBuild)

# ===== Makefile - CI Commands =====

# Run all recipes CI
.PHONY: testAllCI
testAllCI: $(targetsAllCI)

.PHONY: testAllCommands
# Verifies that running all the above commands for a single
# recipe actually works.
testAllCommands:
> $(MAKE)
> $(MAKE) HelloWorldLog-node
> $(MAKE) HelloWorldLog-build
> $(MAKE) HelloWorldLog-buildWeb
> $(MAKE) HelloWorldLog-buildProd
