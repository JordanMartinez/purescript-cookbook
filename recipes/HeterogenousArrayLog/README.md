# HeterogenousArrayLog

This recipe demonstrates how to create a heterogenous array and process its elements.

PureScript arrays are _homogeneous_, meaning that all values must have the same type. If you want to store values with different types in the same array (i.e. a _heterogeneous_ array), you should wrap all the types you wish to store in either a [sum type](https://github.com/purescript/documentation/blob/master/language/Types.md#tagged-unions) or a [Variant](https://pursuit.purescript.org/packages/purescript-variant). This recipe demonstrates both strategies.

## Expected Behavior:

Prints the following:
```
---- Using Sum Type ----
["a String value","4","true","false","82.4"]

---- Using Variant Type ----
["a String value","4","true","false","82.4"]
```