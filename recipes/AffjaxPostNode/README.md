# AffjaxPostNode

Performs a simple HTTP Post request using Affjax library.

The post data that is sent with the request makes use of the PureScript Argonaut library to reduce the boilerplate needed to serialize and de-serialize the JSON.
The user should note that there may be good reasons to provide this boilerplate explicitly, however, as detailed in this [blog post](https://code.slipthrough.net/2018/03/13/thoughts-on-typeclass-codecs/)

NB: this recipe depends upon the continuing availability of the dummy JSON provider "http://jsonplaceholder.typicode.com/posts"

## Expected Behavior:

Prints to the console:

`-- POST http://jsonplaceholder.typicode.com/posts response: {"userId":22,"title":"title","id":101,"body":"body"}`

## Dependencies used

When used in Node.js this code depends up on [xhr2](https://www.npmjs.com/package/xhr2)

This recipe is only implemented for Node.js as of this initial commit but it can be made run in the browser instead and no `xhr2` dependency would apply in that case.

### Node.js

Prints the contents of this repo's LICENSE file. Note that this recipe is run from the repo's root directory.
