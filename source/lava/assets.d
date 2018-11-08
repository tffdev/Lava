module assets;

import std.stdio;
import std.container.array;
import std.string;
import derelict.sdl2.sdl;
import derelict.sdl2.image;
import derelict.sdl2.ttf;

import screen;
import error;

TTF_Font* fontm5x7;

Sprite debugTextSprite;
Array!(string) debugTextBuffer;

immutable DEBUGALPHABET = " !+#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~";

private SDL_Texture* loadImageToTexture(string filename){
  SDL_Surface* imageBuffer = IMG_Load(cast(char*)filename);
  SDL_Texture* textureBuffer = SDL_CreateTextureFromSurface(screen.renderer, imageBuffer);
  SDL_FreeSurface(imageBuffer);
  return textureBuffer;
}

public void drawText(string textToDraw, int x, int y){
  if(!fontm5x7){
    fontm5x7 = TTF_OpenFont("source/lava/m5x7.ttf", 15);
  }
  SDL_Color color = { 0, 0, 0 };
  SDL_Surface* surface = TTF_RenderText_Solid(fontm5x7, cast(char*)textToDraw, color);
  SDL_Texture* fontRender = SDL_CreateTextureFromSurface(screen.renderer, surface);
  SDL_Rect a = { 0, 0, surface.w, surface.h };
  SDL_Rect b = { x, y, surface.w, surface.h };
  SDL_FreeSurface(surface);
  SDL_RenderCopy(screen.renderer,fontRender,&a,&b);
  SDL_DestroyTexture(fontRender);
}

public void drawDebugText(string input) {
  if(!debugTextSprite){
    debugTextSprite = new Sprite("source/lava/debugFont.gif", 12, 13);
  }
  debugTextBuffer ~= input;
}

public void outputDebugText() {
  for (int row = 0; row < debugTextBuffer.length(); row++){
    string text = debugTextBuffer[row];
    for(int i=0; i<text.length;i++){
      char letter = text[i];
      screen.drawSprite(debugTextSprite, 
        cast(int)indexOf(DEBUGALPHABET, letter), 5+i*9, 5+15*row);
    }
  }
  debugTextBuffer.clear();
}

class Sprite {
  string spriteFilename;
  SDL_Texture* texture;

  bool hflip;
  bool vflip;

  int spriteWidth;
  int spriteHeight;
  int subimageWidth;
  int subimageHeight;
  SDL_Rect[] subimageQuads;

  this(string filename, int inpSubimageWidth, int inpSubimageHeight){
    spriteFilename = filename;
    texture = loadImageToTexture(filename);
    if(texture == null) {
      error.report(error.missingFile, filename);
    }
    SDL_QueryTexture(texture, null, null, &spriteWidth, &spriteHeight);
    subimageWidth = inpSubimageWidth;
    subimageHeight = inpSubimageHeight;
    createSubimageQuads();
  }
  
  void createSubimageQuads() {
    int xcMax = cast(int)(spriteWidth/subimageWidth);
    int ycMax = cast(int)(spriteHeight/subimageHeight);
    for(int yc = 0; yc < ycMax; yc++){
      for(int xc = 0; xc < xcMax; xc++){
        SDL_Rect rect = { subimageWidth*xc, subimageHeight*yc, subimageWidth, subimageHeight };
        subimageQuads ~= rect;
      }
    }
  }

  SDL_Rect getRectAtIndex(int index){
    if(subimageQuads.length - 1 < index){
      error.report(error.outOfBounds, format("%d %s", index, spriteFilename));
      return subimageQuads[0];
    }
    return subimageQuads[index];
  }
}
