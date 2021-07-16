# MemoizeFibonacci

This recipe demonstrates correct and incorrect use of the [`memoize`](https://pursuit.purescript.org/packages/purescript-memoize/docs/Data.Function.Memoize#v:memoize) function by calculating the fibonacci sequence.

## Expected Behavior:

### Node.js

Prints the following to console, which demonstrates `fibFast` is memoized correctly, while `fibSlow` is not.

```
basic fib result: 13
fibFast 1: 1
fibFast 0: 0
fibFast 2: 1
fibFast 3: 2
fibFast 4: 3
fibFast 5: 5
fibFast 6: 8
fibFast 7: 13
fibFast result: 13
fibSlow 1: 1
fibSlow 0: 0
fibSlow 1: 1
fibSlow 2: 1
fibSlow 3: 2
fibSlow 0: 0
fibSlow 1: 1
fibSlow 2: 1
fibSlow 1: 1
fibSlow 0: 0
fibSlow 1: 1
fibSlow 2: 1
fibSlow 3: 2
fibSlow 4: 3
fibSlow 5: 5
fibSlow 0: 0
fibSlow 1: 1
fibSlow 2: 1
fibSlow 1: 1
fibSlow 0: 0
fibSlow 1: 1
fibSlow 2: 1
fibSlow 3: 2
fibSlow 4: 3
fibSlow 1: 1
fibSlow 0: 0
fibSlow 1: 1
fibSlow 2: 1
fibSlow 3: 2
fibSlow 0: 0
fibSlow 1: 1
fibSlow 2: 1
fibSlow 1: 1
fibSlow 0: 0
fibSlow 1: 1
fibSlow 2: 1
fibSlow 3: 2
fibSlow 4: 3
fibSlow 5: 5
fibSlow 6: 8
fibSlow 7: 13
fibSlow result: 13
```

### Browser

Prints same output as above to dev console when the page is loaded.

Make sure to open the console with dev tools first, then reload/refresh the page.