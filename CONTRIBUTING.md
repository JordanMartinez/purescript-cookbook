# Contributing new recipes

The instructions appear first with the rationale behind them appearing later.

### Instructions

Follow these instructions for contributing new recipes:
1. Open a new issue making a request for a recipe. This helps avoid two developers working on the same recipe independently.
1. Pick an existing recipe to duplicate as a starting point. The `HelloWorld` recipe is probably the simplest.
1. Rename the copied folder to a short description of the problem you're trying to solve using PascalCase (e.g. RoutingPushHalogen)
1. If your recipe is incompatible with the browser enviornment (e.g. reading local files with node), delete the `dev` directory. Note that just logging to the console **is** supported in the browser.
1. Use your recipe name to prefix all modules. Do a quick search to find all instances of the old recipe name to replace (e.g. `grep -r RoutingPushHalogen .`).
1. Install needed dependencies via `spago recipes/RecipeName/spago.dhall install <packageName>`
1. Implement your recipe
1. Rember to update your recipe's readme
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
