# ValueBasedJsonCodecLog

This recipe shows how to use [`codec`](https://pursuit.purescript.org/packages/purescript-codec/3.0.0) and [`codec-argonaut`](https://pursuit.purescript.org/packages/purescript-codec-argonaut/) to write value-based bidirectional JSON codecs to encode and decode examples written in "meta-language."

The JSON we'll be encoding and decoding is:
```json
{
  "string":"string value",
  "boolean": true,
  "int": 4,
  "number": 42.0,
  "array": [
    "elem 1",
    "elem 2",
    "elem 3"
  ],
  "record": {
    "foo": "bar",
    "baz": 8
  },
  "sumTypesNoTags": [
    "Nothing",
    "Just 1"
  ],
  "sumTypeWithTags": [
    {"tag": "Noting"},
    {"tag": "Just", "value": 1}
  ],
  "productTypesNoLabels": [
    1,
    true,
    "stuff"
  ],
  "productTypesWithLabels": {
    "key1": "value1",
    "key2": "value2",
    "key3": "value3"
  }
}
```

## Expected Behavior:

Prints the following to the console:
```
Verify codec is bidirectional
Rountrip 1: decode (encode x) == x:
true
Rountrip 2: encode (decode x) == x
true



Decoding the example JSON
{ array: ["elem 1","elem 2","elem 3"], boolean: true, int: 4, number: 42.0, productTypesNoLabels: IntBooleanString(1 true "stuff"), productTypesWithLabels: IntBooleanString(1 true "stuff"), record: { baz: 8, foo: "bar" }, string: "string value", sumTypeWithTags: [Nothing,(Just 1)], sumTypesNoTags: [Nothing,(Just 1)] }


Encoding the example value:
{"array":["elem 1","elem 2","elem 3"],"boolean":true,"int":4,"number":42,"productTypesNoLabels":[1,true,"stuff"],"productTypesWithLabels":{"key1":1,"key2":true,"key3":"stuff"},"record":{"baz":8,"foo":"bar"},"string":"string value","sumTypeWithTags":[{"tag":"Nothing"},{"tag":"Just","value":1}],"sumTypesNoTags":["Nothing","Just 1"]}
```

If running this code in the Browser environment, make sure to open the console with dev tools first, then reload/refresh the page.
