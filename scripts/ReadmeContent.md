# PureScript-Cookbook

An unofficial Cookbook for PureScript
([Quick link to recipes table](./README.md#recipes))

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
```sh
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
make HelloLog-node
...

=== Web Recipes ===
make WindowProperties-web
make HelloLog-web
...
```

Then simply copy and paste one of the listed commands. For example:

Running a node-compatible recipe:
```
> make HelloLog-node
=== Running HelloLog on the Node.js backend ===
[info] Installation complete.
[info] Build succeeded.
Hello world!
```

Running a web-compatible recipe:
```
> make HelloLog-web
=== Building HelloLog ===
[info] Installation complete.
[info] Build succeeded.
=== Launching HelloLog in the web browser ===
...
```

## Current Recipe Suffixes

| Recipes ending with ... | ... mean the following approach/library is used |
| - | - |
| `HalogenClassic` | [Component-style Halogen](https://github.com/purescript-halogen/purescript-halogen/)  |
| `HalogenHooks` | [Hooks-style Halogen](https://github.com/thomashoneyman/purescript-halogen-hooks/) |
| `ReactClassic` | [Component-style React](https://github.com/lumihq/purescript-react-basic-classic) via [react-basic](https://github.com/lumihq/purescript-react-basic) |
| `ReactHooks` | [Hooks-style React](https://github.com/spicydonuts/purescript-react-basic-hooks/) via [react-basic](https://github.com/lumihq/purescript-react-basic) |
| `Concur` | [Concur](https://github.com/purescript-concur/purescript-concur-react) |
| `Js` | Run plain PureScript **only** on the web (no node.js) without a web framework |
| `Log` | Log content to **both** the browser's dev console and the terminal |
| `Node` | Run PureScript **only** on Node.js where no user interaction occurs |
| `CLI` | Run PureScript **only** on Node.js with user interaction |
