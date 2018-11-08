module game;
import std.stdio;
import std.conv;
import derelict.sdl2.sdl;
import derelict.sdl2.image;
import screen;
import assets;
import keyboard;

private GameObject[] gameObjects;

/* Base Object template */
class GameObject {
  int x;
  int y;
  void step(){};
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
      step();
      keyboard.clearPressedKeys();
      if(quit){break;}
    }
    SDL_Delay(1);
  }
}

void step(){
  screen.clear();
  /* update and draw stuff */
  foreach(object; gameObjects) {
    object.step();
  }
  screen.present();
}

void addObject(GameObject obj){
  game.gameObjects ~= obj;
}

bool handleEvent(SDL_Event e){
  switch(e.type){
    case SDL_QUIT: return true;
    case SDL_KEYDOWN: if(e.key.repeat == 0) keyboard.passPressedKey(e.key.keysym);
    break;
    case SDL_KEYUP: if(e.key.repeat == 0) keyboard.passLiftedKey(e.key.keysym);
    break;
    case SDL_WINDOWEVENT:
    if(e.window.event == SDL_WINDOWEVENT_RESIZED){
      printf("Window %d size changed to %dx%d",
              e.window.windowID, e.window.data1,
              e.window.data2);
    }
    break;
    default: break;
  }
  return false;
}
