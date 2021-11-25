# HeterogeneousLog

This recipe demonstrates how to use [`purescript-heterogeneous`](https://pursuit.purescript.org/packages/purescript-heterogeneous/0.3.0) to manipulate records generically.

## Expected Behavior:

### Node.js

Prints the following to the console.

```
======================
Mapping
======================
GetFirst: { field1: 1, field2: true, field3: "a value", field4: (Just [1]) }
OverwriteValues 1: { field1: 1, field2: 1, field3: 1, field4: 1 }
OverwriteValues 2: { field1: "something else", field2: "something else", field3: "something else", field4: "something else" }

======================
MappingWithIndex
======================
ReflectFieldLabels: { field1: "field1", field2: "field2", field3: "field3", field4: "field4" }

======================
Folding
======================
AsNestedTuple - FieldCount 0: unit
AsNestedTuple - FieldCount 1: (Tuple 1 unit)
AsNestedTuple - FieldCount 2: (Tuple 2 (Tuple 1 unit))
AsNestedTuple - FieldCount 4: (Tuple (Just 4) (Tuple "stuff" (Tuple unit (Tuple 1 unit))))

======================
FoldingWithIndex
======================
Prefix: { prefix-one: 1, prefix-two: "foo" }
Suffix: { one-suffix: 1, two-suffix: "foo" }
```

### Browser

Prints the following to the console.

```
======================
Mapping
======================
GetFirst: { field1: 1, field2: true, field3: "a value", field4: (Just [1]) }
OverwriteValues 1: { field1: 1, field2: 1, field3: 1, field4: 1 }
OverwriteValues 2: { field1: "something else", field2: "something else", field3: "something else", field4: "something else" }

======================
MappingWithIndex
======================
ReflectFieldLabels: { field1: "field1", field2: "field2", field3: "field3", field4: "field4" }

======================
Folding
======================
AsNestedTuple - FieldCount 0: unit
AsNestedTuple - FieldCount 1: (Tuple 1 unit)
AsNestedTuple - FieldCount 2: (Tuple 2 (Tuple 1 unit))
AsNestedTuple - FieldCount 4: (Tuple (Just 4) (Tuple "stuff" (Tuple unit (Tuple 1 unit))))

======================
FoldingWithIndex
======================
Prefix: { prefix-one: 1, prefix-two: "foo" }
Suffix: { one-suffix: 1, two-suffix: "foo" }
```

Make sure to open the console with dev tools first, then reload/refresh the page.
