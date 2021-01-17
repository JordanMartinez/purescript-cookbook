# ComponentsReactHooks

Demonstrates how to nest one React Hooks-based component inside another and send props from the parent to the child component.

## Expected Behavior:

### Browser

Clicking the "On/Off" button in the child will toggle the button's label and update the parent component's toggle count. If the user clicks the "Check now" button in the parent, the parent will update its cache of the button state.
The parent will also display how many times it has been re-rendered.

## Dependencies Used:

[react](https://www.npmjs.com/package/react)
[react-dom](https://www.npmjs.com/package/react-dom)
