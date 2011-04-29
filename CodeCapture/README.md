CodeCapture
===========

This sample is inspired by the [KonamiCode] thread.

This is a simple library, which can be used to register a sequence of codes (key and/or mouse pressess), ofr which the given function should be called.

The code is implemented as a simple finite state machine, so you can register many different codes at the same time, and if they share a common prefix, they also share the state.

This sample has several magic codes:
 * "qwerty"
 * "second"
 * "secundo"
 * KONAMI (UP UP DOWN DOWN LEFT RIGHT LEFT RIGHT b a)
 * a MOUSE-LEFT b MOUSE-RIGHT
 * "quit" and "exit"

Each sequence causes the change of text displayed, except the last ones, which quit the program.

[KonamiCode]: http://love2d.org/forums/viewtopic.php?f=5&t=2632

