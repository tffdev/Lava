import std.stdio;

import screen;
import assets;
import game;
import keyboard;

import std.format;

void main()
{  
  screen.init("oofy", 640, 480, 2);  
  game.add_object(new Girl(50, 50));
  game.enter_event_loop();
}


class Girl : GameObject {
  double sprite_index = 0;
  Sprite main_sprite;

  this(int ix, int iy){
    x = ix;
    y = iy;
    main_sprite = new Sprite("images/tg.png", 32, 32);
  }

  override void step() {
    sprite_index = sprite_index+0.1;
    if(sprite_index>=4) sprite_index=0;
    
    screen.draw_sprite(main_sprite, cast(int)sprite_index, x, y);

    if(keyboard.is_pressed("A")){
      writeln("A has been pressed!");
    }
  }
}
