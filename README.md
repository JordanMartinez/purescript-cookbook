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
# Remove purescript and spago and removing trailing , from package.json
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

## Recipes

**Note:** for the `try` links in the "Web Browser" column, any content logged to the console will appear in the web browser's console, not in the page rendered by Try PureScript.

| Node | Web Browser | Recipe | Description |
| :-: | :-: | - | - |
|   | :heavy_check_mark: ([try](https://try.purescript.org/?github=/JordanMartinez/purescript-cookbook/master/recipes/AceEditorHalogenHooks/src/Main.purs) - [fixme](recipes/AceEditorHalogenHooks/tryFixMe.md)) | [AceEditorHalogenHooks](recipes/AceEditorHalogenHooks) | A Halogen Hooks port of the ["Ace Editor" Halogen Example](https://github.com/purescript-halogen/purescript-halogen/tree/master/examples/ace). |
|   | :heavy_check_mark: ([try](https://try.purescript.org/?github=/JordanMartinez/purescript-cookbook/master/recipes/AddRemoveEventListenerJs/src/Main.purs) - [fixme](recipes/AddRemoveEventListenerJs/tryFixMe.md)) | [AddRemoveEventListenerJs](recipes/AddRemoveEventListenerJs) | This recipe shows how to add and remove an event listener to an HTML element. |
| :heavy_check_mark: |   | [AffjaxPostNode](recipes/AffjaxPostNode) | Performs a simple HTTP Post request using the [Affjax](https://pursuit.purescript.org/packages/purescript-affjax/) library. |
|   | :heavy_check_mark: ([try](https://try.purescript.org/?github=/JordanMartinez/purescript-cookbook/master/recipes/BasicHalogenHooks/src/Main.purs)) | [BasicHalogenHooks](recipes/BasicHalogenHooks) | Displays a button that toggles the label to "On" and "Off". |
| :heavy_check_mark: | :heavy_check_mark: ([try](https://try.purescript.org/?github=/JordanMartinez/purescript-cookbook/master/recipes/BigIntJs/src/Main.purs)) | [BigIntJs](recipes/BigIntJs) | This recipe shows how to print, create, and use values of the `BigIntJs` type in either the node.js or web browser console. |
|   | :heavy_check_mark: ([try](https://try.purescript.org/?github=/JordanMartinez/purescript-cookbook/master/recipes/BookHalogenHooks/src/Main.purs)) | [BookHalogenHooks](recipes/BookHalogenHooks) | A Halogen port of the ["HTTP - Book" Elm Example](https://elm-lang.org/examples/book). |
|   | :heavy_check_mark: ([try](https://try.purescript.org/?github=/JordanMartinez/purescript-cookbook/master/recipes/BookReactHooks/src/Main.purs)) | [BookReactHooks](recipes/BookReactHooks) | A React port of the ["HTTP - Book" Elm Example](https://elm-lang.org/examples/book). |
|   | :heavy_check_mark: ([try](https://try.purescript.org/?github=/JordanMartinez/purescript-cookbook/master/recipes/ButtonsHalogenHooks/src/Main.purs)) | [ButtonsHalogenHooks](recipes/ButtonsHalogenHooks) | A Halogen port of the ["User Input - Buttons" Elm Example](https://elm-lang.org/examples/buttons). |
|   | :heavy_check_mark: ([try](https://try.purescript.org/?github=/JordanMartinez/purescript-cookbook/master/recipes/ButtonsReactHooks/src/Main.purs)) | [ButtonsReactHooks](recipes/ButtonsReactHooks) | A React port of the ["User Input - Buttons" Elm Example](https://elm-lang.org/examples/buttons). |
| :heavy_check_mark: |   | [CapabilityPatternNode](recipes/CapabilityPatternNode) | A skeletal version of an application structuring pattern |
|   | :heavy_check_mark: ([try](https://try.purescript.org/?github=/JordanMartinez/purescript-cookbook/master/recipes/CardsHalogenHooks/src/Main.purs)) | [CardsHalogenHooks](recipes/CardsHalogenHooks) | A Halogen port of the ["Random - Cards" Elm Example](https://elm-lang.org/examples/cards). |
|   | :heavy_check_mark: ([try](https://try.purescript.org/?github=/JordanMartinez/purescript-cookbook/master/recipes/CardsReactHooks/src/Main.purs)) | [CardsReactHooks](recipes/CardsReactHooks) | A React port of the ["Random - Cards" Elm Example](https://elm-lang.org/examples/cards). |
|   | :heavy_check_mark: ([try](https://try.purescript.org/?github=/JordanMartinez/purescript-cookbook/master/recipes/ClockReactHooks/src/Main.purs)) | [ClockReactHooks](recipes/ClockReactHooks) | A React port of the ["User Interface - Clock" Elm Example](https://elm-lang.org/examples/clock). |
|   | :heavy_check_mark: ([try](https://try.purescript.org/?github=/JordanMartinez/purescript-cookbook/master/recipes/ComponentsHalogenHooks/src/Main.purs)) | [ComponentsHalogenHooks](recipes/ComponentsHalogenHooks) | Demonstrates how to nest one Halogen-Hooks-based component inside another and send/receive queries between the two. |
|   | :heavy_check_mark: ([try](https://try.purescript.org/?github=/JordanMartinez/purescript-cookbook/master/recipes/ComponentsInputHalogenHooks/src/Main.purs)) | [ComponentsInputHalogenHooks](recipes/ComponentsInputHalogenHooks) | Each time a parent re-renders, it will pass a new input value into the child, and the child will update accordingly. |
|   | :heavy_check_mark: ([try](https://try.purescript.org/?github=/JordanMartinez/purescript-cookbook/master/recipes/ComponentsInputReactHooks/src/Main.purs)) | [ComponentsInputReactHooks](recipes/ComponentsInputReactHooks) | Each time the parent's state updates, it will pass a new prop value into the child, and the child will update accordingly. |
|   | :heavy_check_mark: ([try](https://try.purescript.org/?github=/JordanMartinez/purescript-cookbook/master/recipes/ComponentsMultiTypeHalogenHooks/src/Main.purs)) | [ComponentsMultiTypeHalogenHooks](recipes/ComponentsMultiTypeHalogenHooks) | Demonstrates a component that can communicate with its children that have differing types. |
|   | :heavy_check_mark: ([try](https://try.purescript.org/?github=/JordanMartinez/purescript-cookbook/master/recipes/ComponentsMultiTypeReactHooks/src/Main.purs)) | [ComponentsMultiTypeReactHooks](recipes/ComponentsMultiTypeReactHooks) | Demonstrates a parent component with several children components, each with different prop types. |
|   | :heavy_check_mark: ([try](https://try.purescript.org/?github=/JordanMartinez/purescript-cookbook/master/recipes/ComponentsReactHooks/src/Main.purs)) | [ComponentsReactHooks](recipes/ComponentsReactHooks) | Demonstrates how to nest one React Hooks-based component inside another and send props from the parent to the child component. |
| :heavy_check_mark: | :heavy_check_mark: ([try](https://try.purescript.org/?github=/JordanMartinez/purescript-cookbook/master/recipes/DateTimeBasicsLog/src/Main.purs)) | [DateTimeBasicsLog](recipes/DateTimeBasicsLog) | This recipe shows how to use `purescript-datetime` library to create `Time`, `Date`, and `DateTime` values and adjust/diff them. |
| :heavy_check_mark: | :heavy_check_mark: ([try](https://try.purescript.org/?github=/JordanMartinez/purescript-cookbook/master/recipes/DebuggingLog/src/Main.purs)) | [DebuggingLog](recipes/DebuggingLog) | This recipe shows how to do print-debugging using the `Debug` module's `spy` and `traceM` functions. The compiler will emit warnings to remind you to remove these debug functions before you ship production code. |
| :heavy_check_mark: |   | [DiceCLI](recipes/DiceCLI) | This recipe shows how to create an interactive command line prompt that repeatedly generates a random number between 1 and 6. |
| :heavy_check_mark: | :heavy_check_mark: ([try](https://try.purescript.org/?github=/JordanMartinez/purescript-cookbook/master/recipes/DiceLog/src/Main.purs)) | [DiceLog](recipes/DiceLog) | This recipe shows how to log a random integer between 1 and 6 (representing a roll of a die) in either the node.js or web browser console. |
|   | :heavy_check_mark: ([try](https://try.purescript.org/?github=/JordanMartinez/purescript-cookbook/master/recipes/DogImagesHalogenHooks/src/Main.purs)) | [DogImagesHalogenHooks](recipes/DogImagesHalogenHooks) | Fetches random dog images from the [Dog API](https://dog.ceo/dog-api/). |
|   | :heavy_check_mark: ([try](https://try.purescript.org/?github=/JordanMartinez/purescript-cookbook/master/recipes/DogImagesReactHooks/src/Main.purs)) | [DogImagesReactHooks](recipes/DogImagesReactHooks) | Fetches random dog images from the [Dog API](https://dog.ceo/dog-api/). |
|   | :heavy_check_mark: ([try](https://try.purescript.org/?github=/JordanMartinez/purescript-cookbook/master/recipes/DragAndDropHalogenHooks/src/Main.purs)) | [DragAndDropHalogenHooks](recipes/DragAndDropHalogenHooks) | A Halogen port of the ["Files - Drag-and-Drop" Elm Example](https://elm-lang.org/examples/drag-and-drop). |
|   | :heavy_check_mark: ([try](https://try.purescript.org/?github=/JordanMartinez/purescript-cookbook/master/recipes/DragAndDropReactHooks/src/Main.purs)) | [DragAndDropReactHooks](recipes/DragAndDropReactHooks) | A React port of the ["Files - Drag-and-Drop" Elm Example](https://elm-lang.org/examples/drag-and-drop). |
|   | :heavy_check_mark: ([try](https://try.purescript.org/?github=/JordanMartinez/purescript-cookbook/master/recipes/DriverIoHalogenHooks/src/Main.purs)) | [DriverIoHalogenHooks](recipes/DriverIoHalogenHooks) | Demonstrates how to communicate with a Halogen application by sending messages to and receiving messages from the root-level component via the driver. |
|   | :heavy_check_mark: | [DriverRoutingHalogenHooks](recipes/DriverRoutingHalogenHooks) | Demonstrates using `hashchange` events to drive the root component in a Halogen application via the driver. |
|   | :heavy_check_mark: ([try](https://try.purescript.org/?github=/JordanMartinez/purescript-cookbook/master/recipes/DriverWebSocketsHalogenHooks/src/Main.purs)) | [DriverWebSocketsHalogenHooks](recipes/DriverWebSocketsHalogenHooks) | Demonstrates using a WebSocket to drive the main component in a Halogen application. |
|   | :heavy_check_mark: ([try](https://try.purescript.org/?github=/JordanMartinez/purescript-cookbook/master/recipes/FileUploadHalogenHooks/src/Main.purs)) | [FileUploadHalogenHooks](recipes/FileUploadHalogenHooks) | A Halogen port of the ["Files - Upload" Elm Example](https://elm-lang.org/examples/upload). |
|   | :heavy_check_mark: ([try](https://try.purescript.org/?github=/JordanMartinez/purescript-cookbook/master/recipes/FileUploadReactHooks/src/Main.purs)) | [FileUploadReactHooks](recipes/FileUploadReactHooks) | A React port of the ["Files - Upload" Elm Example](https://elm-lang.org/examples/upload). |
|   | :heavy_check_mark: | [FindDomElementJs](recipes/FindDomElementJs) | This recipe shows how to find elements in the DOM by using query selectors. |
|   | :heavy_check_mark: ([try](https://try.purescript.org/?github=/JordanMartinez/purescript-cookbook/master/recipes/FormsReactHooks/src/Main.purs)) | [FormsReactHooks](recipes/FormsReactHooks) | A React port of the ["User Interface - Forms" Elm Example](https://elm-lang.org/examples/forms). |
|   | :heavy_check_mark: ([try](https://try.purescript.org/?github=/JordanMartinez/purescript-cookbook/master/recipes/GroceriesHalogenHooks/src/Main.purs)) | [GroceriesHalogenHooks](recipes/GroceriesHalogenHooks) | A Halogen port of the ["HTML - Groceries" Elm Example](https://elm-lang.org/examples/groceries). |
|   | :heavy_check_mark: ([try](https://try.purescript.org/?github=/JordanMartinez/purescript-cookbook/master/recipes/GroceriesJs/src/Main.purs)) | [GroceriesJs](recipes/GroceriesJs) | A framework-free port of the ["HTML - Groceries" Elm Example](https://elm-lang.org/examples/groceries). |
|   | :heavy_check_mark: ([try](https://try.purescript.org/?github=/JordanMartinez/purescript-cookbook/master/recipes/GroceriesReactHooks/src/Main.purs)) | [GroceriesReactHooks](recipes/GroceriesReactHooks) | A React port of the ["HTML - Groceries" Elm Example](https://elm-lang.org/examples/groceries). |
|   | :heavy_check_mark: ([try](https://try.purescript.org/?github=/JordanMartinez/purescript-cookbook/master/recipes/HelloHalogenHooks/src/Main.purs)) | [HelloHalogenHooks](recipes/HelloHalogenHooks) | A Halogen port of the ["HTML - Hello" Elm Example](https://elm-lang.org/examples/hello). |
|   | :heavy_check_mark: ([try](https://try.purescript.org/?github=/JordanMartinez/purescript-cookbook/master/recipes/HelloJs/src/Main.purs)) | [HelloJs](recipes/HelloJs) | A framework-free port of the ["HTML - Hello" Elm Example](https://elm-lang.org/examples/hello). |
| :heavy_check_mark: | :heavy_check_mark: ([try](https://try.purescript.org/?github=/JordanMartinez/purescript-cookbook/master/recipes/HelloLog/src/Main.purs)) | [HelloLog](recipes/HelloLog) | This recipe shows how to run a simple "Hello world!" program in either the node.js or web browser console. |
|   | :heavy_check_mark: ([try](https://try.purescript.org/?github=/JordanMartinez/purescript-cookbook/master/recipes/HelloReactHooks/src/Main.purs)) | [HelloReactHooks](recipes/HelloReactHooks) | A React port of the ["HTML - Hello" Elm Example](https://elm-lang.org/examples/hello). |
| :heavy_check_mark: | :heavy_check_mark: ([try](https://try.purescript.org/?github=/JordanMartinez/purescript-cookbook/master/recipes/HeterogeneousLog/src/Main.purs)) | [HeterogeneousLog](recipes/HeterogeneousLog) | This recipe demonstrates how to use [`purescript-heterogeneous`](https://pursuit.purescript.org/packages/purescript-heterogeneous/0.3.0) to manipulate records generically. |
| :heavy_check_mark: | :heavy_check_mark: ([try](https://try.purescript.org/?github=/JordanMartinez/purescript-cookbook/master/recipes/HeterogenousArrayLog/src/Main.purs)) | [HeterogenousArrayLog](recipes/HeterogenousArrayLog) | This recipe demonstrates how to create a heterogenous array and process its elements. |
|   | :heavy_check_mark: ([try](https://try.purescript.org/?github=/JordanMartinez/purescript-cookbook/master/recipes/ImagePreviewsHalogenHooks/src/Main.purs) - [fixme](recipes/ImagePreviewsHalogenHooks/tryFixMe.md)) | [ImagePreviewsHalogenHooks](recipes/ImagePreviewsHalogenHooks) | A Halogen port of the ["Files - Drag-and-Drop" Elm Example](https://elm-lang.org/examples/drag-and-drop) with an additional feature to display image thumbnails. |
|   | :heavy_check_mark: ([try](https://try.purescript.org/?github=/JordanMartinez/purescript-cookbook/master/recipes/ImagePreviewsReactHooks/src/Main.purs)) | [ImagePreviewsReactHooks](recipes/ImagePreviewsReactHooks) | A React port of the ["Files - Image-Previews" Elm Example](https://elm-lang.org/examples/image-previews). |
|   | :heavy_check_mark: ([try](https://try.purescript.org/?github=/JordanMartinez/purescript-cookbook/master/recipes/InterpretHalogenHooks/src/Main.purs)) | [InterpretHalogenHooks](recipes/InterpretHalogenHooks) | Demonstrates how to use a custom monad (in this case, using `ReaderT` with `Aff` as the effect type) for a component, and then interpreting that custom monad back down to `Aff`, so it can be run as a normal component. |
|   | :heavy_check_mark: ([try](https://try.purescript.org/?github=/JordanMartinez/purescript-cookbook/master/recipes/KeyboardInputHalogenHooks/src/Main.purs)) | [KeyboardInputHalogenHooks](recipes/KeyboardInputHalogenHooks) | This example demonstrates how to selectively capture keyboard events and, more generally, how to use `EventSource`s in Halogen. |
|   | :heavy_check_mark: ([try](https://try.purescript.org/?github=/JordanMartinez/purescript-cookbook/master/recipes/LifecycleHalogenHooks/src/Main.purs)) | [LifecycleHalogenHooks](recipes/LifecycleHalogenHooks) | Demonstrates component lifecycle. |
|   | :heavy_check_mark: ([try](https://try.purescript.org/?github=/JordanMartinez/purescript-cookbook/master/recipes/NumbersHalogenHooks/src/Main.purs)) | [NumbersHalogenHooks](recipes/NumbersHalogenHooks) | A Halogen port of the ["Random - Numbers" Elm Example](https://elm-lang.org/examples/numbers). |
|   | :heavy_check_mark: ([try](https://try.purescript.org/?github=/JordanMartinez/purescript-cookbook/master/recipes/NumbersReactHooks/src/Main.purs)) | [NumbersReactHooks](recipes/NumbersReactHooks) | A React port of the ["Random - Numbers" Elm Example](https://elm-lang.org/examples/numbers). |
| :heavy_check_mark: | :heavy_check_mark: ([try](https://try.purescript.org/?github=/JordanMartinez/purescript-cookbook/master/recipes/ParallelAppMExampleLog/src/Main.purs)) | [ParallelAppMExampleLog](recipes/ParallelAppMExampleLog) | Demonstrates how to use `parSequence`/`parTraverse` and how to define a `Parallel` instance for a `ReaderT r Aff`-based `AppM` monad. |
|   | :heavy_check_mark: ([try](https://try.purescript.org/?github=/JordanMartinez/purescript-cookbook/master/recipes/PositionsHalogenHooks/src/Main.purs)) | [PositionsHalogenHooks](recipes/PositionsHalogenHooks) | A Halogen port of the ["Random - Positions" Elm Example](https://elm-lang.org/examples/positions). |
|   | :heavy_check_mark: ([try](https://try.purescript.org/?github=/JordanMartinez/purescript-cookbook/master/recipes/PositionsReactHooks/src/Main.purs)) | [PositionsReactHooks](recipes/PositionsReactHooks) | A React port of the ["Random - Positions" Elm Example](https://elm-lang.org/examples/positions). |
| :heavy_check_mark: |   | [RandomNumberGameNode](recipes/RandomNumberGameNode) | This recipe shows how to build a "guess the random number" game using a custom `AppM` monad via the `ReaderT` design pattern and `Aff`, storing the game state in a mutable variable via a `Ref`. |
| :heavy_check_mark: |   | [ReadPrintFileContentsNode](recipes/ReadPrintFileContentsNode) | Reads a file's contents and prints it to the console. |
|   | :heavy_check_mark: | [RoutingHashHalogenClassic](recipes/RoutingHashHalogenClassic) | This recipe shows how to use `purescript-routing` to do client-side hash-based routing in a Halogen-based single-page application (SPA). |
|   | :heavy_check_mark: | [RoutingHashLog](recipes/RoutingHashLog) | This recipe demonstrates hash-based routing with `purescript-routing`. No web framework is used. |
|   | :heavy_check_mark: | [RoutingHashReactHooks](recipes/RoutingHashReactHooks) | This recipe shows how to use `purescript-routing` to do client-side hash-based routing in a React-based single-page application (SPA). |
|   | :heavy_check_mark: | [RoutingPushHalogenClassic](recipes/RoutingPushHalogenClassic) | This recipe shows how to use `purescript-routing` to do client-side push-state routing in a Halogen-based single-page application (SPA). |
|   | :heavy_check_mark: | [RoutingPushReactHooks](recipes/RoutingPushReactHooks) | This recipe shows how to use `purescript-routing` to do client-side push-state routing in a React-based single-page application (SPA). |
| :heavy_check_mark: |   | [RunCapabilityPatternNode](recipes/RunCapabilityPatternNode) | A skeletal version of an application structuring pattern using purescript-run and free dsls. |
|   | :heavy_check_mark: ([try](https://try.purescript.org/?github=/JordanMartinez/purescript-cookbook/master/recipes/ShapesHalogenHooks/src/Main.purs)) | [ShapesHalogenHooks](recipes/ShapesHalogenHooks) | Demonstrates rendering of SVG shapes. |
|   | :heavy_check_mark: ([try](https://try.purescript.org/?github=/JordanMartinez/purescript-cookbook/master/recipes/ShapesReactHooks/src/Main.purs)) | [ShapesReactHooks](recipes/ShapesReactHooks) | Demonstrates rendering of SVG shapes. |
|   | :heavy_check_mark: ([try](https://try.purescript.org/?github=/JordanMartinez/purescript-cookbook/master/recipes/SignalRenderJs/src/Main.purs)) | [SignalRenderJs](recipes/SignalRenderJs) | [Signal](https://pursuit.purescript.org/packages/purescript-signal/10.1.0) demo that responds to user input and elapsed time. |
|   | :heavy_check_mark: ([try](https://try.purescript.org/?github=/JordanMartinez/purescript-cookbook/master/recipes/SignalSnakeJs/src/Main.purs)) | [SignalSnakeJs](recipes/SignalSnakeJs) | A snake game built using [Signal](https://pursuit.purescript.org/packages/purescript-signal/10.1.0). |
|   | :heavy_check_mark: ([try](https://try.purescript.org/?github=/JordanMartinez/purescript-cookbook/master/recipes/SignalTrisJs/src/Main.purs)) | [SignalTrisJs](recipes/SignalTrisJs) | A [tetromino](https://en.wikipedia.org/wiki/Tetromino) game built using [Signal](https://pursuit.purescript.org/packages/purescript-signal/10.1.0). |
| :heavy_check_mark: | :heavy_check_mark: ([try](https://try.purescript.org/?github=/JordanMartinez/purescript-cookbook/master/recipes/SimpleASTParserLog/src/Main.purs)) | [SimpleASTParserLog](recipes/SimpleASTParserLog) | This recipe shows how to parse and evaluate a math expression using parsers and a "precedence climbing" approach. |
|   | :heavy_check_mark: ([try](https://try.purescript.org/?github=/JordanMartinez/purescript-cookbook/master/recipes/TextFieldsHalogenHooks/src/Main.purs)) | [TextFieldsHalogenHooks](recipes/TextFieldsHalogenHooks) | A Halogen port of the ["User Interface - Text Fields" Elm Example](https://elm-lang.org/examples/text-fields). |
|   | :heavy_check_mark: ([try](https://try.purescript.org/?github=/JordanMartinez/purescript-cookbook/master/recipes/TextFieldsReactHooks/src/Main.purs)) | [TextFieldsReactHooks](recipes/TextFieldsReactHooks) | A React port of the ["User Interface - Text Fields" Elm Example](https://elm-lang.org/examples/text-fields). |
|   | :heavy_check_mark: ([try](https://try.purescript.org/?github=/JordanMartinez/purescript-cookbook/master/recipes/TicTacToeReactHooks/src/Main.purs) - [fixme](recipes/TicTacToeReactHooks/tryFixMe.md)) | [TicTacToeReactHooks](recipes/TicTacToeReactHooks) | A PureScript port of the official reactjs.org documentation's [Tutorial: Intro to React](https://reactjs.org/tutorial/tutorial.html) example. |
|   | :heavy_check_mark: ([try](https://try.purescript.org/?github=/JordanMartinez/purescript-cookbook/master/recipes/TimeHalogenHooks/src/Main.purs)) | [TimeHalogenHooks](recipes/TimeHalogenHooks) | A Halogen port of the ["Time - Time" Elm Example](https://elm-lang.org/examples/time). |
|   | :heavy_check_mark: ([try](https://try.purescript.org/?github=/JordanMartinez/purescript-cookbook/master/recipes/TimeReactHooks/src/Main.purs)) | [TimeReactHooks](recipes/TimeReactHooks) | A React port of the ["User Interface - Time" Elm Example](https://elm-lang.org/examples/time). |
| :heavy_check_mark: | :heavy_check_mark: ([try](https://try.purescript.org/?github=/JordanMartinez/purescript-cookbook/master/recipes/ValueBasedJsonCodecLog/src/Main.purs)) | [ValueBasedJsonCodecLog](recipes/ValueBasedJsonCodecLog) | This recipe shows how to use [`codec`](https://pursuit.purescript.org/packages/purescript-codec/3.0.0) and [`codec-argonaut`](https://pursuit.purescript.org/packages/purescript-codec-argonaut/) to write value-based bidirectional JSON codecs to encode and decode examples written in "meta-language." |
|   | :heavy_check_mark: ([try](https://try.purescript.org/?github=/JordanMartinez/purescript-cookbook/master/recipes/WindowPropertiesJs/src/Main.purs)) | [WindowPropertiesJs](recipes/WindowPropertiesJs) | This recipe shows how to get and print various properties in the browser's `window` object. |
| :heavy_check_mark: |   | [WriteFileNode](recipes/WriteFileNode) | Writes a `String` to a text file using UTF-8 encoding. |
