# AffGameSnakeJs

A snake game built using [AffGame](https://pursuit.purescript.org/packages/purescript-game/2.0.0).

This was rewritten from [SignalSnakeJs](../SignalSnakeJs) with changes to use `AffGame` instead of `Signal` to run the game.

## Expected Behavior

### Browser

Renders a [game of snake](https://en.wikipedia.org/wiki/Snake_(video_game_genre)) in the browser. Use the arrow keys to change the direction of the "snake" and eat "food" to grow. The game automatically restarts when running out of bounds or into the snake tail.
