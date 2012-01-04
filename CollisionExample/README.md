Collision example
===========

This sample is inspired by the [RestrictRectangleMovement] thread.

The sample illustrates (in just one of many ways) how you can restrict movement
of your cursor (character) to stay on screen and not go thru other obstacles.

How the collision works.
========================

Every new frame function love.update() checks if any of the arrow keys is pressed, and if so, computes the new position of the character, keeping the old position ofr reference. Then the function checks if this new position is off-screen (by calling isOnScreen()), or if the character at this new position collides with any other object. If there is collision, then the move is not allowed, so the previously stored position is recalled, and the new position is discarded.

Every object has its position x,y and its size - width w and height. So the collision is detected when any two rectangles collide.

[RestrictRectangleMovement]: http://love2d.org/forums/viewtopic.php?f=3&t=5072

