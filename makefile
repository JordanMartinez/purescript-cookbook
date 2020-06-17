# ------------- Common --------------

# Favor local npm devDependencies if they are installed
export PATH := node_modules/.bin:$(PATH)

# Use `PHONY` because target name is not an actual file
.PHONY: list info

# Prints all the recipes one could run via make and clarifying text.
# For now, we assume that each recipe has a `run` and `serve` command,
# but not all of these will work.
list:
	@echo Use \"make RecipeName-target\" to run a recipe
	@echo
	@echo === RECIPES ===
	@echo $(foreach r,$(recipes),make_$(r)-{run,serve}) | tr ' ' '\n' | tr '_' ' '

# Prints version and path information.
# For troubleshooting version mismatches.
info:
	which purs
	purs --version
	which spago
	spago version
	which parcel
	parcel --version

# Tests if recipe actually exists.
# This should be a dependency of all entry targets
recipes/%:
	test -d $* || { echo "Recipe $* does not exist"; exit 1;}

# -------- Pattern matching strategy -----------

# Usage:
#
# make Template-run
# make Template-serve
# make Template-buildDev
# make Template-buildProd

# Targets for all recipe build operations
recipes := $(shell ls recipes)
recipesBuild := $(foreach r,$(recipes),$(r)-build)
recipesNode := $(foreach r,$(recipes),$(r)-node)
recipesBrowser := $(foreach r,$(recipes),$(r)-browser)
recipesBuildDev := $(foreach r,$(recipes),$(r)-buildDev)
recipesBuildProd := $(foreach r,$(recipes),$(r)-buildProd)

# Use `PHONY` because target name is not an actual file
.PHONY: recipesBuild recipesNode recipesBrowser recipesBuildDev recipesBuildProd buildAll buildAllDev buildAllProd

# Helper functions for generating paths
main = $1.Main
recipeDir = recipes/$1
recipeSpago = $(call recipeDir,$1)/spago.dhall

devDir = $(call recipeDir,$1)/dev
devHtml = $(call devDir,$1)/index.html
devDistDir = $(call recipeDir,$1)/dev-dist

prodDir = $(call recipeDir,$1)/prod
prodHtml = $(call prodDir,$1)/index.html
prodJs = $(call prodDir,$1)/index.js
prodDistDir = $(call recipeDir,$1)/prod-dist

# Builds a single recipe. A build is necessary before parcel commands.
%-build:
	spago -x $(call recipeSpago,$*) build

# Runs recipe as node.js console app
%-node: $(call recipeDir,%)
	spago -x $(call recipeSpago,$*) run --main $(call main,$*)

# Launches recipe in browser
%-browser: $(call recipeDir,%) $(call $*-build,%)
	parcel $(call devHtml,$*) --out-dir $(call devDistDir,$*) --open

# Uses parcel to quickly create an unminified build.
# For CI purposes.
%-buildDev: export NODE_ENV=development
%-buildDev: $(call $*-build,%) $(call recipeDir,%)
	parcel build $(call devHtml,$*) --out-dir $(call devDistDir,$*) --no-minify --no-source-maps

# How to make prodDir
$(call prodDir,$(recipes)):
	mkdir -p $@

# How to make prodHtml
recipes/%/prod/index.html: $(call prodDir,%)
	cp $(call devHtml,$*) $(call prodDir,$*)

# Creates a minified production build.
# For reference.
%-buildProd: $(call recipeDir,%) $(call prodHtml,%)
	spago -x $(call recipeSpago,$*) bundle-app --main $(call main,$*) --to $(call prodJs,$*)
	parcel build $(call prodHtml,$*) --out-dir $(call prodDistDir,$*)

# All purs builds - for CI
buildAll: $(recipesBuild)

# All dev builds - for CI
buildAllDev: $(recipesBuildDev)

# All prod builds - for CI
buildAllProd: $(recipesBuildProd)
