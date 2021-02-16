# CapabilityPatternWithCheckedExceptionsNode

An enhancement of the CapabilityPattern Recipe, which adds `typed-exceptions`

It's best to be completely familiar with the design and implementation of that recipe before looking at this one. 

Additionally, you should familiarize yourself with the [README](https://github.com/natefaubion/purescript-checked-exceptions) from `checked-exceptions`.

## Expected Behavior:

The `main` runs the `program` in a specialized monadic context (`AppExcVM`) which provides `Reader`, `Aff` and `ExceptV` instances in addition to the _capabilities_ required by the `program`, namely ability to `log` and `getUserName`. 

In the implementation of `getUserName` we - somewhat artificially - use two additional services, each of which can give rise to a class of thrown errors / exceptions. We show how, provided these errors are all matched to error handling functions, the exceptions can be guaranteed not to escape from our monadic context.

### Node.js

Prints the contents of this repo's LICENSE file. Note that this recipe is run from the repo's root directory.



