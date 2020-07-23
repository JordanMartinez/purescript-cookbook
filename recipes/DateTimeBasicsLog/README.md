# DateTimeBasicsLog

This recipe shows how to use `purescript-datetime` library to create `Time`, `Date`, and `DateTime` values and adjust/diff them.

## Expected Behavior:

Prints the following to the console. For the browser environement, make sure to open the console with dev tools first, then reload/refresh the page:
```
To create a specific part of a `Time` value, you must use the `toEnum` function. This ensures that the value you provide is within the correct bounds.
For example, a Minute must be between 0 and 59. If you happen to pass it -1, what should it's value be? Should it be clamped to 0? Or should it be set to 59? Rather than deciding for you, it forces you to do the checking by using `toEnum` to return a `Maybe Minute`.
toEnum 4: (Just (Minute 4))
toEnum -8: Nothing
toEnum 69: Nothing
The same goes for Hour (0 - 23), Second (0 - 59), and Millisecond (0 - 999).
toEnum 4: (Just (Hour 4))
toEnum -8: Nothing
toEnum 69: Nothing
To create a `Time` value, you use the `Maybe` monad and do notation:
mkTime 4 24 4 3: (Just (Time (Hour 4) (Minute 24) (Second 4) (Millisecond 3)))
mkTime 42 842 2 -42: Nothing
To create a `Date` value, we use the `Maybe` monad again:
mkCanonicalDate 2016 Feb 31: (Just (Date (Year 2016) March (Day 2)))
mkExactDate 2016 Feb 31: Nothing
mkExactDate 2016 Feb 27: (Just (Date (Year 2016) February (Day 27)))
mkDateTime 2016 Feb 27 @ 11:04:14:423: (Just (DateTime (Date (Year 2016) February (Day 27)) (Time (Hour 11) (Minute 4) (Second 14) (Millisecond 423))))
Original DateTime: (DateTime (Date (Year 2016) February (Day 27)) (Time (Hour 11) (Minute 4) (Second 14) (Millisecond 423)))
Add five seconds: (Just (DateTime (Date (Year 2016) February (Day 27)) (Time (Hour 11) (Minute 4) (Second 19) (Millisecond 423))))
Add two days: (Just (DateTime (Date (Year 2016) February (Day 29)) (Time (Hour 11) (Minute 4) (Second 14) (Millisecond 423))))
Add four hours: (Just (DateTime (Date (Year 2016) February (Day 27)) (Time (Hour 15) (Minute 4) (Second 14) (Millisecond 423))))
Number of Days between two dateTimes: (Days 1.0)
```
