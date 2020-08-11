# ValueBasedJsonCodecLog

This recipe shows how to use [`codec`]() and [`codec-argonaut`]() to encode and decode JSON written in "meta-language."

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

### Node.js

Prints "Hello world!" to console.

### Browser

Prints "Hello world!" to console when the page is loaded.

Make sure to open the console with dev tools first, then reload/refresh the page.
