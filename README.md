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

## Current Recipe Suffixes

| Recipes ending with ... | ... mean the following approach/library is used |
| - | - |
| `HalogenClassic` | Component-style Halogen  |
| `HalogenHooks` | Hooks-style Halogen |
| `ReactClassic` | Component-style React via [react-basic](https://github.com/lumihq/purescript-react-basic) |
| `ReactHooks` | Hooks-style React via [react-basic](https://github.com/lumihq/purescript-react-basic) |
| `Js` | Run plain PureScript on the web without a web framework |
| `Log` | Log content to both the browser's console and the terminal |
| `Node` | Run PureScript on Node.js where no user interaction occurs |
| `CLI` | Run PureScript on Node.js with user interaction |

## Recipes

| Node | Web Browser | Recipe | Description |
| :-: | :-: | - | - |
|   | :heavy_check_mark: | [AddRemoveEventListenerJs](recipes/AddRemoveEventListenerJs) | This recipe shows how to add and remove an event listener to an HTML element. |
| :heavy_check_mark: | :heavy_check_mark: | [BigIntJs](recipes/BigIntJs) | This recipe shows how to print, create, and use values of the `BigIntJs` type in either the node.js or web browser console. |
|   | :heavy_check_mark: | [BookHalogenHooks](recipes/BookHalogenHooks) | A Halogen port of the ["HTTP - Book" Elm Example](https://elm-lang.org/examples). |
|   | :heavy_check_mark: | [BookReactHooks](recipes/BookReactHooks) | A React port of the ["HTTP - Book" Elm Example](https://elm-lang.org/examples/book). |
|   | :heavy_check_mark: | [ButtonsHalogenHooks](recipes/ButtonsHalogenHooks) | A Halogen port of the ["User Input - Buttons" Elm Example](https://elm-lang.org/examples). |
|   | :heavy_check_mark: | [ButtonsReactHooks](recipes/ButtonsReactHooks) | A React port of the ["User Input - Buttons" Elm Example](https://elm-lang.org/examples/buttons). |
|   | :heavy_check_mark: | [CardsHalogenHooks](recipes/CardsHalogenHooks) | A Halogen port of the ["Random - Cards" Elm Example](https://elm-lang.org/examples/cards). |
|   | :heavy_check_mark: | [CardsReactHooks](recipes/CardsReactHooks) | A React port of the ["Random - Cards" Elm Example](https://elm-lang.org/examples/cards). |
|   | :heavy_check_mark: | [CatGifsHalogenHooks](recipes/CatGifsHalogenHooks) | A Halogen port of the ["HTTP - Cat GIFs" Elm Example](https://elm-lang.org/examples). |
|   | :heavy_check_mark: | [CatGifsReactHooks](recipes/CatGifsReactHooks) | A React port of the ["HTTP - Cat GIFs" Elm Example](https://elm-lang.org/examples/cat-gifs). |
| :heavy_check_mark: | :heavy_check_mark: | [DebuggingLog](recipes/DebuggingLog) | This recipe shows how to do print-debugging using the `Debug` module's `spy` and `traceM` functions. The compiler will emit warnings to remind you to remove these debug functions before you ship production code. |
| :heavy_check_mark: |   | [DiceCLI](recipes/DiceCLI) | This recipe shows how to create an interactive command line prompt that repeatedly generates a random number between 1 and 6. |
| :heavy_check_mark: | :heavy_check_mark: | [DiceLog](recipes/DiceLog) | This recipe shows how to log a random integer between 1 and 6 (representing a roll of a die) in either the node.js or web browser console. |
|   | :heavy_check_mark: | [DragAndDropHalogenHooks](recipes/DragAndDropHalogenHooks) | A Halogen port of the ["Files - Drag-and-Drop" Elm Example](https://elm-lang.org/examples/drag-and-drop). |
|   | :heavy_check_mark: | [FileUploadHalogenHooks](recipes/FileUploadHalogenHooks) | A Halogen port of the ["Files - Upload" Elm Example](https://elm-lang.org/examples/upload). |
|   | :heavy_check_mark: | [FindDomElementJs](recipes/FindDomElementJs) | This recipe shows how to find elements in the DOM by using query selectors. |
|   | :heavy_check_mark: | [GroceriesHalogenHooks](recipes/GroceriesHalogenHooks) | A Halogen port of the ["HTML - Groceries" Elm Example](https://elm-lang.org/examples). |
|   | :heavy_check_mark: | [GroceriesReactHooks](recipes/GroceriesReactHooks) | A React port of the ["HTML - Groceries" Elm Example](https://elm-lang.org/examples). |
|   | :heavy_check_mark: | [HelloHalogenHooks](recipes/HelloHalogenHooks) | A Halogen port of the ["HTML - Hello" Elm Example](https://elm-lang.org/examples). |
| :heavy_check_mark: |   | [HelloNode](recipes/HelloNode) | Equivalent to `HelloWorldLog` recipe, but just targets node.js environment (not the browser too). For CI testing until another node-only recipe is created. |
|   | :heavy_check_mark: | [HelloReactHooks](recipes/HelloReactHooks) | A React port of the ["HTML - Hello" Elm Example](https://elm-lang.org/examples). |
| :heavy_check_mark: | :heavy_check_mark: | [HelloWorldLog](recipes/HelloWorldLog) | This recipe shows how to run a simple "Hello world!" program in either the node.js or web browser console. |
|   | :heavy_check_mark: | [ImagePreviewsHalogenHooks](recipes/ImagePreviewsHalogenHooks) | A Halogen port of the ["Files - Drag-and-Drop" Elm Example](https://elm-lang.org/examples/drag-and-drop). |
|   | :heavy_check_mark: | [NumbersHalogenHooks](recipes/NumbersHalogenHooks) | A Halogen port of the ["Random - Numbers" Elm Example](https://elm-lang.org/examples). |
|   | :heavy_check_mark: | [NumbersReactHooks](recipes/NumbersReactHooks) | A React port of the ["Random - Numbers" Elm Example](https://elm-lang.org/examples/numbers). |
|   | :heavy_check_mark: | [PositionsHalogenHooks](recipes/PositionsHalogenHooks) | A Halogen port of the ["Random - Positions" Elm Example](https://elm-lang.org/examples). |
|   | :heavy_check_mark: | [PositionsReactHooks](recipes/PositionsReactHooks) | A React port of the ["Random - Positions" Elm Example](https://elm-lang.org/examples/positions). |
| :heavy_check_mark: |   | [ReadPrintFileContentsNode](recipes/ReadPrintFileContentsNode) | Reads a file's contents and prints it to the console. |
|   | :heavy_check_mark: | [RoutingHashHalogenClassic](recipes/RoutingHashHalogenClassic) | This recipe shows how to use `purescript-routing` to do client-side hash-based routing in a Halogen-based single-page application (SPA). |
|   | :heavy_check_mark: | [RoutingHashLog](recipes/RoutingHashLog) | This recipe demonstrates hash-based routing with `purescript-routing`. No web framework is used. |
|   | :heavy_check_mark: | [RoutingPushHalogenClassic](recipes/RoutingPushHalogenClassic) | This recipe shows how to use `purescript-routing` to do client-side push-state routing in a Halogen-based single-page application (SPA). |
|   | :heavy_check_mark: | [TextFieldsHalogenHooks](recipes/TextFieldsHalogenHooks) | A Halogen port of the ["User Interface - Text Fields" Elm Example](https://elm-lang.org/examples). |
|   | :heavy_check_mark: | [TextFieldsReactHooks](recipes/TextFieldsReactHooks) | A React port of the ["User Interface - Text Fields" Elm Example](https://elm-lang.org/examples/text-fields). |
|   | :heavy_check_mark: | [TimeHalogenHooks](recipes/TimeHalogenHooks) | A Halogen port of the ["Time - Time" Elm Example](https://elm-lang.org/examples). |
|   | :heavy_check_mark: | [WindowPropertiesJs](recipes/WindowPropertiesJs) | This recipe shows how to get and print various properties in the browser's `window` object. |
