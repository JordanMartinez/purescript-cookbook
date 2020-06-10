# Recipe Template

Use this folder to create a new recipe by following these instructions:
1. Create a new recipe request in this repo
2. Copy this folder into the "recipes" folder
3. Rename the copied folder to a short description of the problem you're trying to solve using kebab-case (e.g. routing-in-halogen)
4. If needed, update the `packages.dhall` file to include more packages.
5. Install needed dependencies via `spago install <packageName>`
6. Write the solution to the problem via code
7. Update the copied folder's ReadMe to explain what the recipe does.
8. Submit a PR and state that it "Fixes #X" where X refers to the issue you opened previously

## Problem Description

This example shows how to run a simple "hello world" program.

## Core Libraries Used

- `purescript-prelude`
- `purescript-effect`
- `purescript-console`
