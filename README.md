# PureScript-Cookbook

An unofficial Cookbook for PureScript

The recipes folder contains all the recipes in this repo in no particular order.

## Contributing new recipes

### Principles

#### Only use packages in the latest package set release

In other words, we do not allow anyone to override or add packages in the `packages.dhall` file. If one overrided a given package to make Recipe A work, it might break Recipe B that also relies upon that package. If one added a package that isn't later maintained, it might prevent our CI from passing, which can delay new recipes from being added to this cookbook.
Thus, if you want to use a package that's not in the package set, please add it to the package set. If you want to override a package, please update it in the package set. No exceptions.

### Instructions

Follow these instructions for contributing new recipes:
1. Open a new issue making a request for a recipe. This helps avoid two developers working on the same recipe independently.
1. Pick an existing recipe to duplicate as a starting point. The `Template` recipe is probably the simplest".
1. Rename the copied folder to a short description of the problem you're trying to solve using PascalCase (e.g. RoutingPushHalogen)
1. If your recipe is incompatible with the browser enviornment (e.g. reading local files with node), delete the `dev` directory. Note that just logging to the console **is** supported in the browser.
1. Use your recipe name to prefix all modules. Do a quick search to find all instances of the old recipe name to replace (e.g. `grep -r RoutingPushHalogen .`).
1. Install needed dependencies via `spago install <packageName>`
1. Implement your recipe
1. Rember to update your recipe's readme
1. Submit a PR
