# Contributing new recipes

The instructions for adding a new recipe appear first with the rationale behind them appearing later. After that, we explain why we decided to use `make` as our build tool and provide a few resources to help developers get more familiar with it. Note: learning `make` isn't required to add a recipe. Those who are curious can learn more from this repo's example.

### Instructions

Follow these instructions for contributing new recipes:
1. Open a new issue making a request for a recipe. This helps avoid two developers working on the same recipe independently.
1. Pick an existing recipe to duplicate as a starting point. The `HelloWorld` recipe is probably the simplest.
1. Rename the copied folder to a short description of the problem you're trying to solve using PascalCase (e.g. RoutingPushHalogen)
1. If your recipe is incompatible with the browser enviornment (e.g. reading local files with node), delete the `dev` directory. Note that just logging to the console **is** supported in the browser.
1. Use your recipe name to prefix all modules. Do a quick search to find all instances of the old recipe name to replace (e.g. `grep -r RoutingPushHalogen .`).
1. Install needed dependencies via `spago -x recipes/RecipeName/spago.dhall install <packageName>`
1. Implement your recipe
1. Update your recipe's `README.md` file.
     - Put the fully summary of your recipe on the 3rd line without any newlines. This is what will appear in the repo's Recipe section's Table of Contents.
1. Regenerate the table of recipes by running `make readme`
1. Submit a PR

### Principles

#### Only use packages in the latest package set release

In other words, we do not allow anyone to override or add packages in the `packages.dhall` file for the following reasons:
- Reduces the burden of maintenance for maintainers of this repo
- Overriding package A to make Recipe X work now might prevent Recipe Y from working (which doesn't need the override)
- Somewhat reduces the attack surface of malicious recipes (e.g. including a malicious package via addition/override)

Thus, if you want to use a package that's not in the package set, please add it to the package set. Any PRs that use packages not in the package set will not be merged until all of their packages are in the package set.

By implication, recipes that use packages that get dropped from the package set will be moved to the `broken-recipes` folder.

#### All Recipes are Licensed under This Repo's License (MIT)

All recipes are licensed under MIT. If you want to submit a new recipe but cannot agree to these terms, please open an issue to discuss it further. Unless you have special circumstances that provide a strong enough rationale to change how we should handle recipe licensing, we will not merge your PR.

## Using `Make` as our build tool

There are three parties whose concerns we wanted to keep in mind:
1. End users of this library - make it easy to run recipes
1. Recipe-writers - make it easy to add new recipes
1. Maintainers of this cookbook - make it easy to test CI and remove broken or outdated recipes

We considered the following build tools:
- npm scripts: already installed on most end-users' computers but not very flexible or powerful for what we had in mind
- `scriptlauncher`: nicer UI than npm scripts but still suffered from the same lack of power
- `make`: already installed on most users' computers, powerful, and a bit of a learning curve

`make` seemed like the best choice between these options. We didn't consider other options for better or worse.

See these sources for help in understanding what the `makefile` is doing:
- [Official Manual (somewhat hard to read/understand)](https://www.gnu.org/software/make/manual/make.html)
- [Makefile tutorial (quick summary of manual with missing parts)](https://makefiletutorial.com/)
- [Make Guide (slides)](http://martinvseticka.eu/temp/make/normal.html)
- [Make Cheatsheet](http://eduardolezcano.com/wp-content/uploads/2016/06/make_cheatsheet.pdf)
- [Automatic Variables (i.e. what `$*`, `$%`, `$@`, etc. mean)](https://www.gnu.org/software/make/manual/make.html#Automatic-Variables)
- [Your Makefiles are wrong](https://tech.davis-hansson.com/p/make/)
