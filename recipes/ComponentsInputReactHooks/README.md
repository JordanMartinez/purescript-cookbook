# ComponentsInputReactHooks

Each time the parent's state updates, it will pass a new prop value into the child, and the child will update accordingly.

## Expected Behavior:

### Browser

The parent stores an `Int` as state. Clicking the buttons will increment/decrement that value. The children will display the result of a mathematical computation using that value.
The parent will also display how many times it has been rendered.

## Dependencies Used:

[react](https://www.npmjs.com/package/react)
[react-dom](https://www.npmjs.com/package/react-dom)
