# PayloadHttpApiNode

Implements a simple 'quote' API using the [payload](https://github.com/hoodunit/purescript-payload) HTTP backend.

## Expected Behavior:

### Node.js

HTTP server is started. You can call the API using your favorite HTTP client.
This example uses [httpie](https://httpie.org/):
```sh
# get all quotes
http get 'http://localhost:3000/quote'

# get the default initial quote
http get 'http://localhost:3000/quote/1'

# add a quote
echo "This is a new quote" | http post 'http://localhost:3000/quote'

# retrieve it
http get 'http://localhost:3000/quote/1'

# get all quotes again
http get 'http://localhost:3000/quote'
```
