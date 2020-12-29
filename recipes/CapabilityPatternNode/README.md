# CapabilityPatternNode

A skeletal version of an application structuring pattern

See the readme in https://github.com/afcondon/purescript-capability-pattern

## Expected Behavior:

The `main` runs the `program` (see linked readme) in three successive, different monad contexts: `Aff`, `Effect` and `Test`. 

In order to show both succeeding and failing test, the program will end by crashing on failed `assert` of second test.

### Node.js

Prints the contents of this repo's LICENSE file. Note that this recipe is run from the repo's root directory.
