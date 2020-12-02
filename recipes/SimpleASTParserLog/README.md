# SimpleASTParserLog

This recipe shows how to parse and evaluate a math expression using parsers and a "precedence climbing" approach.

`@natefaubion` and `@kritzcreek` were both very helpful in providing initial guidance on how to implement this.

## Expected Behavior:

### Node.js

Prints the following to the console:
```
Problem is: 1 + 2 * 3 - 4 / 5
6.2 = 1 + 2 * 3 - 4 / 5
Structure is: BinaryOp(BinaryOp(UnaryOp(Unary(Positive LitInt 1)) + BinaryOp(UnaryOp(Unary(Positive LitInt 2)) * UnaryOp(Unary(Positive LitInt 3)))) - BinaryOp(UnaryOp(Unary(Positive LitInt 4)) / UnaryOp(Unary(Positive LitInt 5))))

Problem is: (-1) + 2 - ((3 + 4) - 5) * (-(6 + 7 * (8 + 9))) / -10
-24.0 = (-1) + 2 - ((3 + 4) - 5) * (-(6 + 7 * (8 + 9))) / -10
Structure is: BinaryOp(BinaryOp(UnaryOp(Unary(Positive Parenthesis(UnaryOp(Unary(Negative LitInt 1))))) + UnaryOp(Unary(Positive LitInt 2))) - BinaryOp(BinaryOp(UnaryOp(Unary(Positive Parenthesis(BinaryOp(UnaryOp(Unary(Positive Parenthesis(BinaryOp(UnaryOp(Unary(Positive LitInt 3)) + UnaryOp(Unary(Positive LitInt 4)))))) - UnaryOp(Unary(Positive LitInt 5)))))) * UnaryOp(Unary(Positive Parenthesis(UnaryOp(Unary(Negative Parenthesis(BinaryOp(UnaryOp(Unary(Positive LitInt 6)) + BinaryOp(UnaryOp(Unary(Positive LitInt 7)) * UnaryOp(Unary(Positive Parenthesis(BinaryOp(UnaryOp(Unary(Positive LitInt 8)) + UnaryOp(Unary(Positive LitInt 9))))))))))))))) / UnaryOp(Unary(Negative LitInt 10))))

Problem is: -1 + -2 - -3 - -4 * 4 * 5 * -6
-480.0 = -1 + -2 - -3 - -4 * 4 * 5 * -6
Structure is: BinaryOp(BinaryOp(UnaryOp(Unary(Negative LitInt 1)) + BinaryOp(UnaryOp(Unary(Negative LitInt 2)) - UnaryOp(Unary(Negative LitInt 3)))) - BinaryOp(BinaryOp(UnaryOp(Unary(Negative LitInt 4)) * BinaryOp(UnaryOp(Unary(Positive LitInt 4)) * UnaryOp(Unary(Positive LitInt 5)))) * UnaryOp(Unary(Negative LitInt 6))))
```

### Browser

Make sure to open the console with dev tools first, then reload/refresh the page.

Prints the following to the console:
```
Problem is: 1 + 2 * 3 - 4 / 5
6.2 = 1 + 2 * 3 - 4 / 5
Structure is: BinaryOp(BinaryOp(UnaryOp(Unary(Positive LitInt 1)) + BinaryOp(UnaryOp(Unary(Positive LitInt 2)) * UnaryOp(Unary(Positive LitInt 3)))) - BinaryOp(UnaryOp(Unary(Positive LitInt 4)) / UnaryOp(Unary(Positive LitInt 5))))

Problem is: (-1) + 2 - ((3 + 4) - 5) * (-(6 + 7 * (8 + 9))) / -10
-24.0 = (-1) + 2 - ((3 + 4) - 5) * (-(6 + 7 * (8 + 9))) / -10
Structure is: BinaryOp(BinaryOp(UnaryOp(Unary(Positive Parenthesis(UnaryOp(Unary(Negative LitInt 1))))) + UnaryOp(Unary(Positive LitInt 2))) - BinaryOp(BinaryOp(UnaryOp(Unary(Positive Parenthesis(BinaryOp(UnaryOp(Unary(Positive Parenthesis(BinaryOp(UnaryOp(Unary(Positive LitInt 3)) + UnaryOp(Unary(Positive LitInt 4)))))) - UnaryOp(Unary(Positive LitInt 5)))))) * UnaryOp(Unary(Positive Parenthesis(UnaryOp(Unary(Negative Parenthesis(BinaryOp(UnaryOp(Unary(Positive LitInt 6)) + BinaryOp(UnaryOp(Unary(Positive LitInt 7)) * UnaryOp(Unary(Positive Parenthesis(BinaryOp(UnaryOp(Unary(Positive LitInt 8)) + UnaryOp(Unary(Positive LitInt 9))))))))))))))) / UnaryOp(Unary(Negative LitInt 10))))

Problem is: -1 + -2 - -3 - -4 * 4 * 5 * -6
-480.0 = -1 + -2 - -3 - -4 * 4 * 5 * -6
Structure is: BinaryOp(BinaryOp(UnaryOp(Unary(Negative LitInt 1)) + BinaryOp(UnaryOp(Unary(Negative LitInt 2)) - UnaryOp(Unary(Negative LitInt 3)))) - BinaryOp(BinaryOp(UnaryOp(Unary(Negative LitInt 4)) * BinaryOp(UnaryOp(Unary(Positive LitInt 4)) * UnaryOp(Unary(Positive LitInt 5)))) * UnaryOp(Unary(Negative LitInt 6))))
```
