import std.stdio;
import std.format;

import screen;
import assets;
import game;
import keyboard;
import maps;
import derelict.sdl2.sdl;
import derelict.sdl2.image;

void main()
{ 
  screen.init("oofy", 640, 480, 2, true);  
  maps.loadMap("maps/map_1.json","images/tileset_forest.png");
  game.addObject(new Girl(50, 50));
  game.enterEventLoop();
}

class Girl : GameObject 
{
  double spriteIndex = 0;
  Sprite mainSprite;

  enum Animation : int[] {
    walkUp = [38,39,40,41,42,43,45,46]
  };

  Animation currentAnimation = Animation.walkUp;
  double animationSpeed = 0.2;

  this(int ix, int iy)
  {
    x = ix;
    y = iy;
    mainSprite = new Sprite("images/tg.png", 32, 32);
  }

  override void step()
  {
    spriteIndex = spriteIndex + animationSpeed;
    if(spriteIndex >= currentAnimation.length) spriteIndex=0;
    
    screen.drawSprite(mainSprite, currentAnimation[cast(int)spriteIndex], x, y);

    if(keyboard.isDown("Up")){
      assets.drawDebugText("A has been pressed!");
    }
  }
}