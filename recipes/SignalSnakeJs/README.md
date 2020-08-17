# SignalSnakeJs

A snake game built using [Signal](https://pursuit.purescript.org/packages/purescript-signal/10.1.0).

This was rewritten from [@holdenlee](https://github.com/holdenlee)'s [version](https://github.com/holdenlee/purescript-games) with changes to simplify the code and enable compatibility with TryPureScript.

## Expected Behavior:

### Browser

Renders a [game of snake](https://en.wikipedia.org/wiki/Snake_(video_game_genre)) in the browser. Use the arrow keys to change the direction of the "snake" and eat "food" to grow. The game automatically restarts when running out of bounds or into the snake tail.