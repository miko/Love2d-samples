Sidescroller Collision example
===========

This sample is a follow-up to my earlier [CollisionExample]. This time this is about a sidescroller type of game, where you can only move left or right, and jump up. This collision sample is tile-based, i.e. the obstacles are represented as tile map.

The sample illustrates (in just one of many ways) how you can restrict movement
of your cursor (character) to stay on screen and not go thru other obstacles.

So: move with LEFT/RIGHT, jump with SPACE. Toggle debug with d.

How the collision works.
========================

There are two different cases: one for moving left/right, and another one for fumping up/falling down. You need to check it separately, because you want to move right/left while falling, etc.
The map is tile-based, but the character movement is arbitrary, so you character could occupy more than one tile - you need to check for this when looking for collisions. So first find out which tiles would be occupied, then check if any of them would collide.
There is another constraint of the movement - the character must stay on the map.

[CollisionExample]: https://github.com/miko/Love2d-samples/tree/master/CollisionExample

