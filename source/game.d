module game;

import std.stdio;
import std.conv;

import derelict.sdl2.sdl;
import derelict.sdl2.image;
import screen;
import assets;
import keyboard;

private GameObject[] game_objects;

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
      int presetp = SDL_GetTicks();
      ticks_buffer = ticks_current;
      SDL_Event e;
      bool quit = false;
      while(SDL_PollEvent(&e)){
        switch(e.type){
          case SDL_QUIT: quit = true; break;
          case SDL_KEYDOWN: if(e.key.repeat == 0) keyboard.pass_pressed_key(e.key.keysym);
          break;
          case SDL_KEYUP: if(e.key.repeat == 0) keyboard.pass_lifted_key(e.key.keysym);
          break;
          default: break;
        }
      }
      step();
      keyboard.clear_pressed_keys();
      if(quit){break;}
    }
    SDL_Delay(1);
  }
}

void step(){
  screen.clear();

  /* update and draw stuff */
  foreach(object; game_objects) {
    object.step();
  }

  assets.output_debug_text();
  screen.present();
}

void add_object(GameObject obj){
  game.game_objects ~= obj;
}
