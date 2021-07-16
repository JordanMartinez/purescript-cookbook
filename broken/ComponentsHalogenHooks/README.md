# ComponentsHalogenHooks

Demonstrates how to nest one Halogen-Hooks-based component inside another and send/receive queries between the two.

## Expected Behavior:

### Browser

Clicking the "On/Off" button in the child will toggle the button's label and update the parent component's toggle count. If the user clicks the "Check now" button in the parent, the parent will update its cache of the child's label state.
The parent will also display how many times it has been rendered.
