# CapabilityPatternWithCheckedExceptionsNode

An enhancement of the CapabilityPattern Recipe, which adds `typed-exceptions`

It's best to be completely familiar with the design and implementation of that recipe before looking at this one. 

Additionally, you should familiarize yourself with the [README](https://github.com/natefaubion/purescript-checked-exceptions) from `checked-exceptions`.


## Expected Behavior:

The `main` runs the `program` (see linked readme) in three successive, different monad contexts: `Aff`, `Effect` and `Test`. 

If you want to verify that a failing test would still terminate the process with an error, you can simply uncomment the second call to `Test.runApp`

### Node.js

Prints the contents of this repo's LICENSE file. Note that this recipe is run from the repo's root directory.



