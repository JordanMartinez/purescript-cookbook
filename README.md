# PureScript-Cookbook

An unofficial Cookbook for PureScript

The recipes folder contains all the recipes in this repo in no particular order.

If you want to contribute a new recipe, see the [CONTRIBUTING.md](./CONTRIBUTING.md) file.

## Usage

### Install Dependencies

Install GNU Make, and verify installation with:
```
make --version
```

Install all dependencies locally:
```
make installDeps
```

### Running Recipes

See a list of available recipe launch commands by running:
```
make list
```

Then simply copy and paste one of the listed commands.

## Recipes

| Node | Web Browser | Recipe | Description |
| - | - | - | - |
| :heavy_check_mark: | :heavy_check_mark: | [BigInt](recipes/BigInt) | This recipe shows how to print, create, and use values of the `BigInt` type in either the node.js or web browser console. |
| :heavy_check_mark: |   | [HelloNode](recipes/HelloNode) | Equivalent to `HelloWorld` recipe, but just targets node.js environment (not the browser too). For CI testing until another node-only recipe is created. |
| :heavy_check_mark: | :heavy_check_mark: | [HelloWorld](recipes/HelloWorld) | This recipe shows how to run a simple "Hello world!" program in either the node.js or web browser console. |
| :heavy_check_mark: |   | [ReadPrintFileContents](recipes/ReadPrintFileContents) | Reads a file's contents and prints it to the console. |
|   | :heavy_check_mark: | [RoutingHashHalogen](recipes/RoutingHashHalogen) | This recipe shows how to use `purescript-routing` to do client-side hash-based routing in a Halogen-based single-page application (SPA). |
|   | :heavy_check_mark: | [RoutingHashLog](recipes/RoutingHashLog) | This recipe demonstrates hash-based routing with `purescript-routing`. No web framework is used. |
|   | :heavy_check_mark: | [RoutingPushHalogen](recipes/RoutingPushHalogen) | This recipe shows how to use `purescript-routing` to do client-side push-state routing in a Halogen-based single-page application (SPA). |
|   | :heavy_check_mark: | [WindowProperties](recipes/WindowProperties) | This recipe shows how to get and print various properties in the browser's `window` object. |
