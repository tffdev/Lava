import std.stdio;
import std.format;
import std.algorithm;
import derelict.sdl2.sdl;
import lava;

Sprite background1;

void main()
{ 
  screen.init("oofy", 640, 480, 2, true);  
  maps.loadMap("maps/map_1.json","images/tiles.png");
  game.addObject(new Girl(50, 50));

  background1 = new Sprite("images/bg91.png");

  enterEventLoop();
}

void enterEventLoop(){
  int ticksBuffer = 0;
  while(1){
    int ticksCurrent = SDL_GetTicks();
    if(ticksBuffer + 1000/60 < ticksCurrent){
      int presetp = SDL_GetTicks();
      ticksBuffer = ticksCurrent;
      SDL_Event e;
      bool quit = false;
      while(SDL_PollEvent(&e)){
        quit = handleEvent(e);
      }

      screen.clear();
      // Draw bg
      maps.drawMap();
      game.stepAll();

      assets.outputDebugText();
      screen.present();

      keyboard.clearPressedKeys();
      if(quit){break;}
    }
    SDL_Delay(1);
  }
  game.quit();
}

class Girl : GameObject 
{
  double xvel, yvel = 0;
  bool onground;
  double maxmovespeed = 3;

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
    drawText("This is some TTF text! Hello world!", 10, 120);
    
    if(keyboard.isDown("Left"))  {xvel -= 2; mainSprite.hflip = false;}
    if(keyboard.isDown("Right")) {xvel += 2; mainSprite.hflip = true;}
    if(keyboard.isDown("A") && onground) {y-=1; yvel = -5;}
    applyPhysics();
    assets.drawDebugText(format("girl x, y: %s %s", x, y));
    assets.drawDebugText(format("tile at x, y: %s", getTileAt(cast(int)x+16, cast(int)y+32)));
    
    screen.drawSprite(mainSprite, currentAnimation[cast(int)spriteIndex], x, y);
  }

  void applyPhysics() {
    /* Horizontal movement */
    xvel = clamp(xvel,-maxmovespeed,maxmovespeed);
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
    y+=1;
  }
}