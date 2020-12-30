# CapabilityPatternNode

A skeletal version of an application structuring pattern

Expanded example of the design pattern illustrated in Jordan Martinez'
[reference](https://jordanmartinez.github.io/purescript-jordans-reference-site/content/21-Hello-World/05-Application-Structure/src/02-MTL/32-The-ReaderT-Capability-Design-Pattern.html).

## What's in each "Layer"?

### Layer 4 - Types 

Strong types & pure, total functions on those types

You'd hope to write as much of your code in this layer as possible but in this
skeleton it's intentionally almost empty because we're concerned with the less
obvious business of adapting this bit to your application, infrastructure and
runtime.

### Layer 3 - Application

Effectful functions - `program` and `capabilities`

Called "business logic" in some descriptions of this pattern this layer
contains code that essentially weaves together the concrete code from Layer 4
with the abstract capabilities that can be provided _differently_ in different
scenarios, such as a logging capability that maybe goes to the console in Test
but goes to a Database or a socket or systemd or a logfile in development and
production.

This layer defines:
 * a *program* that will run in some Monad (thus giving you freedom to run it in different Monads, see above)
 * all the *capabilities* that it will require of the Monad in which it runs
 
The capabilities are like "container requirements", an API to a structure in which this program is embedded

### Layer 2 (API) & Layer 1 (Infrastructure) 

Together these two layers define a complete instance of one monadic container for a program
These two layers need to be co-located in one file in PureScript to avoid orphan instances.

Together they define:
 * a particular Monad in which our `program` from Layer 3 can be run
 * a `run` function that runs the `program` in _this_ Monad
 * the instances for the Monad
     * Functor, Apply, Applicative, Bind & Monad can all be derived trivially
     * others that a particular Monad might need can be written explicitly
     * the instances that are required by the `program` in Layer 3, also will have to be written explicitly
 
There are three versions of this monadic container shown here:
 * *ProductionSync* - which runs in Reader & Effect
 * *ProductionAsync* - which runs in Reader & Aff
 * *Test* - which runs in only Reader

 ### Layer 0 - Main
 This layer is where it all comes together. A `main` is called by the underlying runtime and runs the `program` in one or another Monad.

## Expected Behavior:

The `main` runs the `program` (see linked readme) in three successive, different monad contexts: `Aff`, `Effect` and `Test`. 

If you want to verify that a failing test would still terminate the process with an error, you can simply uncomment the second call to `Test.runApp`

### Node.js

Prints the contents of this repo's LICENSE file. Note that this recipe is run from the repo's root directory.



