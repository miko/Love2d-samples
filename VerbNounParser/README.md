SpriteSheet
===========

This sample is inspired by the [verb-noun parser] thread.

The idea is to register a sef of objects (instances of classes with given name and a set of actions, or methods). So you can have classes like Door or Window, and objects, like reddoor, greendoor or window. Now when user writes "open door", the parser first tokenizes this into tokens, then looks for all objects with a name equals to any token ("open", "door"), and when found - for this token, looks for a function called token+"Action" (like "openAction"), and calls it with remaining tokens (minus object name and action name). 

Note that the Door class implements "color discriminator" - if you pass a color name, only door object with this color will respond.

So try following commands:
```
open window
open door
close red door
close green door
Open door
Close door red ad green please!
Please, take the key.
Drop my key now.
exit
```

[verb-noun parser]: http://love2d.org/forums/viewtopic.php?f=4&t=10291

