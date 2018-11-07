module screen;

import derelict.sdl2.sdl;
import derelict.sdl2.image;
import assets;
import std.stdio;
import maps;

SDL_Window* window;
SDL_Renderer* renderer;

SDL_Texture* prescreen_texture;

int window_xsize;
int window_ysize;
int render_scale;

/*
 * - Load SDL2
 * - set window params
 * - create window
 * - create renderer
 * - create render buffer
 */
void init(string window_title, int inp_window_xsize, 
  int inp_window_ysize, int inp_render_scale, bool resizable = true) {
  DerelictSDL2.load();
  DerelictSDL2Image.load();

  window_xsize = inp_window_xsize;
  window_ysize = inp_window_ysize;
  render_scale = inp_render_scale;

  uint window_flags = SDL_WINDOW_SHOWN;
  if (resizable) window_flags |= SDL_WINDOW_RESIZABLE;

  window = SDL_CreateWindow(cast(char*)window_title, SDL_WINDOWPOS_UNDEFINED, 
    SDL_WINDOWPOS_UNDEFINED, window_xsize, window_ysize, window_flags);

  renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_PRESENTVSYNC);

  prescreen_texture = SDL_CreateTexture(renderer, SDL_PIXELFORMAT_RGBA8888, 
    SDL_TEXTUREACCESS_TARGET, inp_window_xsize/inp_render_scale, inp_window_ysize/inp_render_scale);
  
  SDL_SetRenderTarget(renderer, prescreen_texture);
  SDL_AddEventWatch(&event_window, window);
}

void clear(){
  SDL_SetRenderDrawColor(screen.renderer, 255, 255, 255, 255);
  SDL_RenderClear(screen.renderer);
}

void present(){
  draw_map();

  int w, h;
  SDL_GetWindowSize(window, &w, &h);
  

  SDL_Rect prescreen_rect = { 0, 0, window_xsize/render_scale, window_ysize/render_scale };
  SDL_Rect window_rect = { 0, 0, window_xsize, window_ysize };

  // Display on screen
  SDL_SetRenderTarget(renderer, null);
  SDL_RenderCopy(renderer, prescreen_texture, &prescreen_rect, &window_rect);
  assets.output_debug_text();
  SDL_RenderPresent(screen.renderer);
  SDL_SetRenderTarget(renderer, prescreen_texture);
}

void drawSprite(Sprite sprite_to_draw, int index, int x, int y) {
  SDL_Rect onscreen_rect = 
    { x, y, sprite_to_draw.subimage_width, sprite_to_draw.subimage_height };
  
  SDL_Rect sprite_rect = sprite_to_draw.get_rect_at_index(index);

  SDL_Point origin = {0,0};

  SDL_RenderCopyEx(screen.renderer, 
    sprite_to_draw.texture, 
    &sprite_rect, 
    &onscreen_rect, 0.0, 
    &origin, SDL_FLIP_NONE);
}
void setWindowTitle(string title){
  SDL_SetWindowTitle(window, cast(char*)title);
}

// Called when window is modified
extern (C) int event_window(void* data, SDL_Event* event) nothrow {
  return 0;
}