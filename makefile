# Favor local npm devDependencies if they are installed
export PATH := node_modules/.bin:$(PATH)

# Use the `>` character rather than tabs for indentation
ifeq ($(origin .RECIPEPREFIX), undefined)
  $(error This Make does not support .RECIPEPREFIX. Please use GNU Make 4.0 or later)
endif
.RECIPEPREFIX = >

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

# Tests if recipe actually exists.
recipes/%:
> @test -d $* || { echo "Recipe $* does not exist"; exit 1;}

# Test if recipe is compatible with node
recipes/%/nodeSupported.md:
> @test -f $* || { echo "Recipe $* is not compatible with Node.js backend"; exit 1;}

# Test if recipe is compatible with web
recipes/%/web:
> @test -f $* || { echo "Recipe $* is not compatible with web browser backend"; exit 1;}

# Targets for all recipe build operations

recipes := $(shell ls recipes)
targetsBuild := $(foreach r,$(recipes),$(r)-build)

targetsNode := $(patsubst recipes/%/nodeSupported.md,%-node,$(wildcard recipes/*/nodeSupported.md))

recipesWeb := $(patsubst recipes/%/web,%,$(wildcard recipes/*/web))
targetsWeb := $(foreach r,$(recipesWeb),$(r)-web)
targetsBuildWeb := $(foreach r,$(recipesWeb),$(r)-buildWeb)
targetsBuildProd := $(foreach r,$(recipesWeb),$(r)-buildProd)

# Use `PHONY` because target name is not an actual file
.PHONY: targetsBuild targetsNode targetsWeb targetsBuildWeb targetsBuildProd

# Helper functions for generating paths
main = $1.Main
recipeDir = recipes/$1
recipeSpago = $(call recipeDir,$1)/spago.dhall

nodeCompat = $(call recipeDir,$1)/nodeSupported.md

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

# Runs recipe as node.js console app
%-node: $(call recipeDir,%) $(call nodeCompat,%)
> spago -x $(call recipeSpago,$*) run --main $(call main,$*)

# Launches recipe in web browser
%-web: $(call recipeDir,%) $(call webDir,%) %-build
> parcel $(call webHtml,$*) --out-dir $(call webDistDir,$*) --open

# Uses parcel to quickly create an unminified build.
# For CI purposes.
%-buildWeb: export NODE_ENV=development
%-buildWeb: $(call recipeDir,%) $(call webDir,%) %-build
> parcel build $(call webHtml,$*) --out-dir $(call webDistDir,$*) --no-minify --no-source-maps

# How to make prodDir
$(call prodDir,$(recipes)):
> mkdir -p $@

# How to make prodHtml
recipes/%/prod/index.html: $(call prodDir,%)
> cp $(call webHtml,$*) $(call prodDir,$*)

# Creates a minified production build.
# For reference.
%-buildProd: $(call recipeDir,%) $(call prodHtml,%)
> spago -x $(call recipeSpago,$*) bundle-app --main $(call main,$*) --to $(call prodJs,$*)
> parcel build $(call prodHtml,$*) --out-dir $(call prodDistDir,$*)

.PHONY: buildAll runAllNode buildAllWeb buildAllProd

# All purs builds - for CI
buildAll: $(targetsBuild)

# All node executions - for CI
runAllNode: $(targetsNode)

# All web builds - for CI
buildAllWeb: $(targetsBuildWeb)

# All prod builds - for CI
buildAllProd: $(targetsBuildProd)
