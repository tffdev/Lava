module game;
import std.stdio;
import std.format;
import std.conv;
import derelict.sdl2.sdl;
import derelict.sdl2.image;
import screen;
import assets;

GameObject[] game_objects;

/* Base Object template */
class GameObject {
  int x;
  int y;
  void step(){};
}

void enter_event_loop(){
  /* 
   * Event loop 
   * ============
   * todo: key manager
   */
  int ticks_buffer = 0;
  while(1){
    int ticks_current = SDL_GetTicks();
    if(ticks_buffer + 1000/60 < ticks_current){
      ticks_buffer = ticks_current;
      SDL_Event e;
      bool quit = false;
      while(SDL_PollEvent(&e)){
        switch(e.type){
          case SDL_QUIT: quit = true; break;
          case SDL_KEYDOWN: if(e.key.repeat == 0) writeln("v ",to!string(SDL_GetKeyName(e.key.keysym.sym)));
          break;
          case SDL_KEYUP: if(e.key.repeat == 0) writeln("^ ",to!string(SDL_GetKeyName(e.key.keysym.sym)));
          break;
          default: break;
        }
      }
      step();
      if(quit){break;}
    }
  }
}

void step(){
  screen.clear();

  /* Draw stuff */
  foreach(object; game_objects) {
    object.step();
  }

  screen.present();
}

void add_object(GameObject obj){
  game.game_objects ~= obj;
}