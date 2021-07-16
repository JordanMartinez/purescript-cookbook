# ComponentsInputHalogenHooks

Each time a parent re-renders, it will pass a new input value into the child, and the child will update accordingly.

## Expected Behavior:

### Browser

The parent stores an `Int`. Clicking the buttons will increment/decrement that value. The children will produce the result of a mathematical computation using that value.
The parent will also display how many times it has been rendered.
