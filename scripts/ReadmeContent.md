# PureScript-Cookbook

An unofficial Cookbook for PureScript

The recipes folder contains all the recipes in this repo in no particular order.

If you want to contribute a new recipe, see the [CONTRIBUTING.md](./CONTRIBUTING.md) file.

## Usage

### Install Dependencies

Install GNU Make (version 4.0 or above), and verify installation with:
```
make --version
```

Install all dependencies locally:
```
make installDeps
```

Install for Nix users:
```
# Remove purescript and spago and removing traling , from package.json
sed --in-place '/purescript\|spago/d' ./package.json && sed --in-place '$!N;s/,\n  }/\n  }/;P;D' package.json
nix-shell
```

### Running Recipes

See a list of available recipe launch commands by running `make list`:
```
> make list
Use "make RecipeName-target" to run a recipe

=== Node Recipes ===
make ReadPrintFileContents-node
make HelloWorld-node
...

=== Web Recipes ===
make WindowProperties-web
make HelloWorld-web
...
```

Then simply copy and paste one of the listed commands. For example:

Running a node-compatible recipe:
```
> make HelloWorld-node
=== Running HelloWorld on the Node.js backend ===
[info] Installation complete.
[info] Build succeeded.
Hello world!
```

Running a web-compatible recipe:
```
> make HelloWorld-web
=== Building HelloWorld ===
[info] Installation complete.
[info] Build succeeded.
=== Launching HelloWorld in the web browser ===
...
```
