# ParallelAppMExampleLog

Demonstrates how to use `parSequence`/`parTraverse` and how to define a `Parallel` instance for a `ReaderT r Aff`-based `AppM` monad.

The `AppM` file demonstrates how to properly implement a `Parallel` instance when the `AppM` monad is not defined in the same file where it's used.

## Expected Behavior:

Prints the following to the console. If viewing this through the web browser, open the console with dev tools first, then reload/refresh the page:
```
Running computation in 1 second: print all items in array sequentially
1
2
3
4
5
6
7
8
9
10
Running computation in 1 second: print all items in array in parallel
1
3
9
5
4
7
8
2
6
10
Running computation in 1 second: print all items in array in parallel using parTraverse
9
8
7
3
10
2
6
1
5
4
Running computation in 1 second: race multiple computations & stop all others when one finishes
Array 2: 1
Array 3: 1
Array 3: 2
Array 4: 1
Array 3: 3
Array 1: 1
Array 2: 2
Array 2: 3
Array 4: 2
Array 3: 4
Array 4: 3
Array 2: 4
Array 1: 2
Array 4: 4
Array 3: 5
Array 1: 3
Array 4: 5
Array 4: 6
Array 3: 6
Array 2: 5
Array 2: 6
Array 2: 7
Array 4: 7
Array 1: 4
Array 2: 8
Array 3: 7
Array 4: 8
Array 1: 5
Array 3: 8
Array 4: 9
Array 2: 9
Array 3: 9
Array 1: 6
Array 4: 10
```
