# InterpretHalogenHooks

Demonstrates how to use a custom monad (in this case, using `ReaderT` with `Aff` as the effect type) for a component, and then interpreting that custom monad back down to `Aff`, so it can be run as a normal component.

This can be used, for example, to implement a read-only configuration for your application, or a global state if you store a mutable reference.

## Expected Behavior:
