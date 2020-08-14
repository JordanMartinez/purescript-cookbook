# SignalRenderJs

[Signal](https://pursuit.purescript.org/packages/purescript-signal/10.1.0) demo that responds to user input and elapsed time.

## Expected Behavior:

### Browser

Current state is displayed as text in the browser. For example:
```
{ dir: Right, pos: 42 }
```
This indicates a direction to step and a current position.

Every 200ms, the position will increment or decrement based on the current direction.

You may change the direction by pressing either the left or right arrow keys.
