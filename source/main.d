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
  maps.load_map("maps/map_1.json","images/shrinetiles.png");
  game.add_object(new Girl(50, 50));
  game.enter_event_loop();
}

class Girl : GameObject 
{
  double sprite_index = 0;
  Sprite main_sprite;

  enum Animation : int[] {
    walk_up = [38,39,40,41,42,43,45,46]
  };

  Animation current_animation = Animation.walk_up;
  double animation_speed = 0.2;

  this(int ix, int iy)
  {
    x = ix;
    y = iy;
    main_sprite = new Sprite("images/tg.png", 32, 32);
  }

  override void step()
  {
    sprite_index = sprite_index + animation_speed;
    if(sprite_index >= current_animation.length) sprite_index=0;
    
    screen.draw_sprite(main_sprite, current_animation[cast(int)sprite_index], x, y);

    if(keyboard.is_down("Up")){
      assets.draw_debug_text("A has been pressed!");
    }
  }
}