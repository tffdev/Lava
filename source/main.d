import std.stdio;
import std.format;
import std.algorithm;

import lava;

void main()
{ 
  screen.init("oofy", 640, 480, 2, true);  
  maps.loadMap("maps/map_1.json","images/tiles.png");
  game.addObject(new Girl(50, 50));
  game.enterEventLoop();
}


class Girl : GameObject 
{
  double xvel, yvel = 0;
  bool onground;

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
    mainSprite = new Sprite("images/player.png", 32, 32);
  }

  override void step()
  {
    spriteIndex = spriteIndex + animationSpeed;
    if(spriteIndex >= currentAnimation.length) spriteIndex=0;
    assets.drawDebugText(format("Girl's sprite index: %f", spriteIndex));
    screen.drawSprite(mainSprite, currentAnimation[cast(int)spriteIndex], x, y);
    drawText("This is some TTF text! Hello world!", 10, 120);
    
    if(keyboard.isDown("Left"))  {xvel -= 2; mainSprite.hflip = false;}
    if(keyboard.isDown("Right")) {xvel += 2; mainSprite.hflip = true;}
    if(keyboard.isDown("A") && onground) yvel = -5;
    applyPhysics();
    assets.drawDebugText(format("girl x, y: %s %s", x, y));
    assets.drawDebugText(format("tile at x, y: %s", getTileAt(cast(int)x+16, cast(int)y+32)));
  }

  void applyPhysics() {
    /* Horizontal movement */
    xvel = clamp(xvel,-3,3);
    x += xvel;
    xvel /= 1.5;

    int tile = getTileAt(cast(int)x+16, cast(int)y+32);
    /* Gravity and vertical cols */
    if(tile == -1){
      yvel += 0.3;
      yvel = clamp(yvel,-10, 10);
      y += yvel;
      onground = false;
    }

    while(getTileAt(cast(int)x+16, cast(int)y+32) != -1){
      yvel = 0;
      y-=1;
      onground = true;
    }
  }
}