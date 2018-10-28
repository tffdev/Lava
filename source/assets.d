module assets;
import std.stdio;

import derelict.sdl2.sdl;
import derelict.sdl2.image;
import screen;

/*
 * "path/to/image" => [SDL_Texture, quads]
 */  

private SDL_Texture* load_image_to_texture(string filename){
  SDL_Surface* image_buffer = IMG_Load(cast(char*)filename);
  SDL_Texture* texture_buffer 
    = SDL_CreateTextureFromSurface(screen.renderer, image_buffer);
  SDL_FreeSurface(image_buffer);
  return texture_buffer;
}

class Sprite {
  SDL_Texture* texture;

  int sprite_width;
  int sprite_height;
  int subimage_width;
  int subimage_height;
  SDL_Rect[] subimage_quads;

  this(string filename, int inp_subimage_width, int inp_subimage_height){
    texture = load_image_to_texture(filename);
    SDL_QueryTexture(texture, null, null, &sprite_width, &sprite_height);

    subimage_width = inp_subimage_width;
    subimage_height = inp_subimage_height;
    create_subimage_quads();
  }

  void create_subimage_quads() {
    int xc_max = cast(int)(sprite_width/subimage_width);
    int yc_max = cast(int)(sprite_height/subimage_height);
    writeln(xc_max, "  ", yc_max);
    for(int yc = 0; yc < yc_max; yc++){
      for(int xc = 0; xc < xc_max; xc++){
        SDL_Rect rect = { subimage_width*xc, subimage_height*yc, subimage_width, subimage_height };
        writeln(rect, " at index ", yc*xc_max + xc);
        subimage_quads ~= rect;
      }
    }
  }

  SDL_Rect get_rect_at_index(int index){
    return subimage_quads[index];
  }
}