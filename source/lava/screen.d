module screen;
import std.stdio;
import derelict.sdl2.sdl;
import derelict.sdl2.image;
import assets;
import maps;

SDL_Window* window;
SDL_Renderer* renderer;
SDL_Texture* prescreenTexture;
int windowXsize;
int windowYsize;
int renderScale;

/*
 * - Load SDL2
 * - set window params
 * - create window
 * - create renderer
 * - create render buffer
 */
void init(string windowTitle, int inpWindowXsize, 
  int inpWindowYsize, int inpRenderScale, bool resizable = true) {
  DerelictSDL2.load();
  DerelictSDL2Image.load();
  windowXsize = inpWindowXsize;
  windowYsize = inpWindowYsize;
  renderScale = inpRenderScale;
  uint windowFlags = SDL_WINDOW_SHOWN;
  if (resizable) windowFlags |= SDL_WINDOW_RESIZABLE;
  window = SDL_CreateWindow(cast(char*)windowTitle, SDL_WINDOWPOS_UNDEFINED, 
    SDL_WINDOWPOS_UNDEFINED, windowXsize, windowYsize, windowFlags);
  renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_PRESENTVSYNC);
  prescreenTexture = SDL_CreateTexture(renderer, SDL_PIXELFORMAT_RGBA8888, 
    SDL_TEXTUREACCESS_TARGET, inpWindowXsize/inpRenderScale, inpWindowYsize/inpRenderScale);
  SDL_SetRenderTarget(renderer, prescreenTexture);
  SDL_AddEventWatch(&eventWindow, window);
}

void clear(){
  SDL_SetRenderDrawColor(screen.renderer, 255, 255, 255, 255);
  SDL_RenderClear(screen.renderer);
}

void present(){
  drawMap();
  int w, h;
  SDL_GetWindowSize(window, &w, &h);

  SDL_Rect prescreenRect = { 0, 0, windowXsize/renderScale, windowYsize/renderScale };
  SDL_Rect windowRect = { 0, 0, windowXsize, windowYsize };
  // Display on screen
  SDL_SetRenderTarget(renderer, null);
  SDL_RenderCopy(renderer, prescreenTexture, &prescreenRect, &windowRect);
  assets.outputDebugText();
  SDL_RenderPresent(screen.renderer);
  SDL_SetRenderTarget(renderer, prescreenTexture);
}

void drawSprite(Sprite spriteToDraw, int index, int x, int y) {
  SDL_Rect onscreenRect = 
    { x, y, spriteToDraw.subimageWidth, spriteToDraw.subimageHeight };
  
  SDL_Rect spriteRect = spriteToDraw.getRectAtIndex(index);
  SDL_Point origin = {0,0};
  SDL_RenderCopyEx(screen.renderer, 
    spriteToDraw.texture, 
    &spriteRect, 
    &onscreenRect, 0.0, 
    &origin, SDL_FLIP_NONE);
}

void setWindowTitle(string title){
  SDL_SetWindowTitle(window, cast(char*)title);
}

// Called when window is modified
extern (C) int eventWindow(void* data, SDL_Event* event) nothrow {
  return 0;
}