# HeterogenousArrayLog

This recipe shows how to create, display, and pattern match on a heterogenous array.

## Expected Behavior:

Prints the following:
```
[(inj @"typeLevelString" "a String value"),(inj @"int" 4),(inj @"boolean" true),(inj @"boolean" false),(inj @"this type level string must match the label of the row" 82.4)]
------------------
["(inj @\"typeLevelString\" \"a String value\")","(inj @\"int\" 4)","(inj @\"boolean\" true)","(inj @\"boolean\" false)","(inj @\"this type level string must match the label of the row\" 82.4)"]
------------------
["\"a String value\"","4","true","false","82.4"]
------------------
String value: a String value
Int value: 4
Boolean value: true
Boolean value: false
Number value: 82.4
```
