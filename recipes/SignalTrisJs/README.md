# SignalTrisJs

A [tetromino](https://en.wikipedia.org/wiki/Tetromino) game built using [Signal](https://pursuit.purescript.org/packages/purescript-signal/10.1.0).

This was rewritten from [@cheery](https://github.com/cheery)'s [version](https://boxbase.org/entries/2020/aug/5/how-a-haskell-programmer-wrote-a-tris-in-haskell/) version to address some of the concerns outlined in the original blog post.

## Expected Behavior:

### Browser

Renders a game where [tetrominos](https://en.wikipedia.org/wiki/Tetromino) fall from the top of the screen. Use the arrow keys to move and rotate each block. Fill entire rows to eliminate blocks and increase your score. The game speed increases with your score to increase difficulty over time.