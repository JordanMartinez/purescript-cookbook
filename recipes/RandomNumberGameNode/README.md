# RandomNumberGameNode

This recipe shows how to build a "guess the random number" game using a custom `AppM` monad via the `ReaderT` design pattern and `Aff`, storing the game state in a mutable variable via a `Ref`.

## Expected Behavior:

### Node.js

Example output:
```
Guess the random number. It's between 1 and 10. You have 5 guesses. Enter 'q' to quit. Invalid inputs will not count against you.

Prevous guesses: []
Guess a number between 1 - 10: al
'al' is not an integer. Try again (Use 'q' to quit).

Prevous guesses: []
Guess a number between 1 - 10: 52.9
'52.9' is not an integer. Try again (Use 'q' to quit).

Prevous guesses: []
Guess a number between 1 - 10: 52
52 was not between 1 and 10. Try again.

Prevous guesses: []
Guess a number between 1 - 10: 5

Prevous guesses: [5]
Guess a number between 1 - 10: 2

Prevous guesses: [5,2]
Guess a number between 1 - 10: 4

Prevous guesses: [5,2,4]
Guess a number between 1 - 10: 3

Prevous guesses: [5,2,4,3]
Guess a number between 1 - 10: 5
You already guessed 5 previously. Please guess a different number.

Prevous guesses: [5,2,4,3]
Guess a number between 1 - 10: 0
0 was not between 1 and 10. Try again.

Prevous guesses: [5,2,4,3]
Guess a number between 1 - 10: 9
Player lost! The answer was 6
Guesses made: [5,2,4,3,9]
```
