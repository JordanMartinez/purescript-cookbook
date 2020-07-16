# Contributing new recipes

The instructions for adding a new recipe appear first with the rationale behind them appearing later. After that, we explain why we decided to use `make` as our build tool and provide a few resources to help developers get more familiar with it. Note: learning `make` isn't required to add a recipe. Those who are curious can learn more from this repo's example.

### Instructions

Follow these instructions for contributing new recipes. The Goal headers indicate the outcome achieved by following them:

#### Goal 1: Claim and Start Working on a Recipe Request

1. Search currently [open "Recipe Request" issues](https://github.com/JordanMartinez/purescript-cookbook/issues?q=is%3Aissue+is%3Aopen+label%3Arecipe-request).
1. If your recipe idea is unique, open a new ["Recipe Request" issue](https://github.com/JordanMartinez/purescript-cookbook/issues/new?assignees=&labels=recipe-request&template=recipe-request.md&title=)
1. Proceed to the next step if you'd like to implement this recipe yourself.

#### Goal 2: Setup a New Recipe's Boilerplate by Copying a Current Similar One

1. Pick an existing recipe to duplicate as a starting point. The `HelloLog` recipe is the simplest and is set up to work on both Node.js and Browser backends.
    - In the examples that follow, we'll assume that you copied the `HelloLog` recipe and wish to use the "Unique Recipe Name" of `MyNewRecipe`
    ```
    cd recipes
    cp -r HelloLog MyNewRecipe
    ```
1. Rename the copied folder to the "Unique Recipe Name" assigned in the original issue.
1. Depending on the backend-compatibility of your recipe, follow the instructions below:
    1. If your recipe is incompatible with the browser environment, delete the `web` directory.
        - If your recipe uses `node-*` libraries, it is incompatible with the browser.
        - Logging to the console **is** supported in the browser.
    1. If your recipe is incompatible with the Node.js backend, delete the `nodeSupported.md` file.
    1. If your recipe is compatible with Node.js, but the resulting program should not be run during CI (e.g. a program that parses command-line arguments), then rename `nodeSupported.md` to `nodeSupportedSkipCI.md`.
1. Replace all usages of the original recipe's name with your new recipe's name. For example:
    ```
    grep -rl 'HelloLog' MyNewRecipe | xargs sed -i 's/HelloLog/MyNewRecipe/g'
    ```

#### Goal 3: Implement and Submit the Recipe

1. Install all the tools (e.g. `purescript`, `spago`, `parcel`) used in this repo by running `make installDeps`.
1. Install needed PureScript dependencies via `spago`.
    - Due to a [bug in Spago (#654)](https://github.com/purescript/spago/issues/654), follow these instructions:
        1. Change directory into your recipe folder: `cd recipes/MyRecipeName`
        1. Install dependencies as normal: `spago install <packageName>`
        1. Return to the root directory: `cd ../..`
    - **Note**: you can only install dependencies that exist in the latest package set release; you cannot add or override packages in `packages.dhall` (see Principles section for more context).
1. Install needed `npm` dependencies via `npm i <packageName>`. These will be installed to the root folder's `node_modules` folder, not a corresponding folder in the recipe.
    - If you do install `npm` dependencies for your recipe, please state which libraries were installed in the recipe's `README.md` file.
1. Implement your recipe. If you add any new modules, always start the module name with your recipe's "Unique Recipe Name" (e.g. `MyNewRecipe.Foo`, `MyNewRecipe.Module.Path.To.Cool.Types`)
    - Run `make MyNewRecipe-build-watch` while in the root folder if you'd like to automatically rebuild recipes upon changes.
1. Update your recipe's `README.md` file by doing the following things:
    1. Write a summary of your recipe on the 3rd line. This is what will appear in the repo's Recipe section's Table of Contents. Don't add newlines unless you're okay with that additional content being omitted from the table.
    1. Update the "Expected Behavior" section to describe in more detail what should occur when users run your recipe.
    1. Link to any other resources that a reader might find helpful. No need for detailed explanations of libraries here.
    1. List the `npm` dependencies your recipe uses (if any).
1. Regenerate the table of recipes by running `make readme` while in the root folder
1. Submit a PR. The first line should read `Fixes #X` where `X` refers to the original "Recipe Request" issue you claimed.

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

#### Link to Learning Resources Rather than Explaining Here Pedagogical

A cookbook demonstrates how to do X. It does not explain why X works, the concepts that X uses to work, or anything else that could bloat a recipe with very long explanations. Rather, it provides links to resources that users can read if they want to learn more.

#### All Recipes that Use the Same `NPM` Dependency Must Use the Same Version Across All Recipes

For context, this constraint is imposed on us by a limitation. Bundlers (e.g. `parcel`, `esbuild`) cannot find the corresponding `npm` dependency when bundling for the web backend. We fixed this by installing the npm dependency in the root folder's `package.json` file. This isn't ideal and we hope to find a solution that can remove this limitation in the future. However, this constraint will remain until such a solution is found.

Nonetheless, let's say Recipe A through Recipe Y use version 1 of the npm dependency, `foo`, and Recipe Z wants to use version 2 of `foo`. Let's assume Recipes A-Y already exist, and someone submitted a PR to add Recipe Z. Will such a PR be accepted? Yes, provided the following is done:
- in Recipe Z's PR, move Recipes A-Y into the repo's "broken" folder
- in this repo, open an issue for Recipes A-Y so we know to fix it later

After CI passes and the following are done, we will merge the PR.

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
