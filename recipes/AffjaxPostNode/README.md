# AffjaxPostNode

Performs a simple HTTP Post request using Affjax library.

The post data that is sent with the request makes use of argonaut to reduce boilerplate

NB: this recipe depends upon the continuing availability of the dummy JSON provider "http://jsonplaceholder.typicode.com/posts"

## Expected Behavior:

Prints to the console:

`-- POST http://jsonplaceholder.typicode.com/posts response: {"userId":22,"title":"title","id":101,"body":"body"}`

## Dependencies used

[xhr2](https://www.npmjs.com/package/xhr2)

### Node.js

Prints the contents of this repo's LICENSE file. Note that this recipe is run from the repo's root directory.
