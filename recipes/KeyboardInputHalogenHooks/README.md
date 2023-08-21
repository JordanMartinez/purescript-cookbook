# KeyboardInputHalogenHooks

This example demonstrates how to selectively capture keyboard events and, more generally, how to use `EventSource`s in Halogen.

## Expected Behavior:

When the user holds down the shift key and types some characters, the characters will appear on the screen. Once the user presses ENTER or RETURN, the characters will be cleared and the corresponding event listener will be removed.
