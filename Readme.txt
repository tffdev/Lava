LAVA (better name pending)
====================================

TODO:
====================================
- tile meeting algorithms (get map tile width, check each corner of hitbox)
- library function for drawing circles!
- how to implement animations...


PLAN:
====================================
- LITERALLY GAME MAKER BUT OPEN SOURCE
- The only gaping issue is with room creation... 
  make an in-browser level editor?

Lava is going to be a simple 2D game engine that's simple and quick.
I'm aiming for this engine to implement the same features as GameMaker 8.

This means simple interfaces to 
animated sprites, audio, backgrounds, 
keyboard/controller input and timelines.

Currently working on:
  - Documentation
  - Audio interface [oneshots and music loops]
  - Virtual filesystem [don't want all games to ship with a raw folder of assets]

IF YOU'RE TESTING THIS OUT DURING THE CURRENT PROTOTYPE STATE, COPY
THE "resources" FOLDER INTO YOUR GAME'S ROOT DIRECTORY IN ORDER FOR
TTF BLITTING AND REALTIME DEBUG PRINTING TO WORK. IT CONTAINS A DEMO FONT
AND A SPRITE USED AS DEBUG TEXT GLYPHS.

[DEMO m5x7 FONT PROVIDED BY DANIEL LINSSEN @ MANAGORE.ITCH.IO 
https://managore.itch.io/m5x7 ALSO GO PLAY HIS GAMES]

THANK YOU! <3