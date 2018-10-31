module screen;

import derelict.sdl2.sdl;
import derelict.sdl2.image;
import assets;

SDL_Window* window;
SDL_Renderer* renderer;
int window_xsize;
int window_ysize;

void init(string window_title, int inp_window_xsize, int inp_window_ysize, int render_scale) {
  DerelictSDL2.load();
  DerelictSDL2Image.load();

  window_xsize = inp_window_xsize;
  window_ysize = inp_window_ysize;

  window = SDL_CreateWindow(cast(char*)window_title, SDL_WINDOWPOS_UNDEFINED, 
    SDL_WINDOWPOS_UNDEFINED, window_xsize, window_ysize, SDL_WINDOW_SHOWN|SDL_WINDOW_RESIZABLE);
  renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_PRESENTVSYNC);
}

void clear(){
  SDL_SetRenderDrawColor(screen.renderer, 0, 0, 0, 255);
  SDL_RenderClear(screen.renderer);
}

void present(){
  SDL_RenderPresent(screen.renderer);
}

void draw_sprite(Sprite sprite_to_draw, int index, int x, int y) {
  SDL_Rect onscreen_rect = 
    { x, y, sprite_to_draw.subimage_width, sprite_to_draw.subimage_height };
  
  SDL_Rect sprite_rect = sprite_to_draw.get_rect_at_index(index);

  SDL_RenderCopy(screen.renderer, 
    sprite_to_draw.texture, 
    &sprite_rect, 
    &onscreen_rect);
}
void set_window_title(string title){
  SDL_SetWindowTitle(window, cast(char*)title);
}