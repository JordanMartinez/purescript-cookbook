# RunCapabilityPatternNode

A skeletal version of an application structuring pattern using purescript-run and free dsls.

Purescript-run [documentation](https://pursuit.purescript.org/packages/purescript-run/3.0.1)

Expanded example of the original design pattern illustrated in Jordan Martinez'
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

- a _program_ that will run inside [Run](https://pursuit.purescript.org/packages/purescript-run/3.0.1/docs/Run#t:Run)
- free-dsls for each _capability_

The capabilities are like "empty holes" in our program. We fill them in later, in the interpreting stage.

### Layer 2 (API) & Layer 1 (Infrastructure)

Together these two layers define a complete instance of one monadic container for a program.
Together they define:

- a set of base effects we can interpret our base `program` to
- a `run` function that runs the `program` (implemented as a composition of interpreters)

There are three versions of this monadic container shown here:

- _ProductionSync_ - which runs in Effect
- _ProductionAsync_ - which runs in Reader & Aff
- _Test_ - which doesn't need any extra effects to run

### Layer 0 - Main

This layer is where it all comes together. A `main` is called by the underlying runtime and runs the `program` in one or another Monad.

## Expected Behavior:

The `main` runs the `program` (see linked readme) in three successive, different monad contexts: `Aff`, `Effect` and `Test`.

If you want to verify that a failing test would still terminate the process with an error, you can simply uncomment the second call to `Test.runApp`
