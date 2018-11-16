module assets;

import std.stdio;
import std.container.array;
import std.string;
import derelict.sdl2.sdl;
import derelict.sdl2.image;

import lava;

public SDL_Texture* loadImageToTexture(string filename){
  SDL_Surface* imageBuffer = IMG_Load(cast(char*)filename);
  SDL_Texture* textureBuffer = SDL_CreateTextureFromSurface(screen.renderer, imageBuffer);
  SDL_FreeSurface(imageBuffer);
  return textureBuffer;
}

void drawSprite(Sprite spriteToDraw, int index, double x, double y) {
  SDL_Rect onscreenRect = { 
    cast(int)x - ((spriteToDraw.ignoreCamera == true)? 0 : camera.getPositionX()), 
    cast(int)y - ((spriteToDraw.ignoreCamera == true)? 0 : camera.getPositionY()), 
    spriteToDraw.subimageWidth, 
    spriteToDraw.subimageHeight };
  
  SDL_RendererFlip flip = SDL_FLIP_NONE;
  if(spriteToDraw.hflip){flip |= SDL_FLIP_HORIZONTAL;}
  if(spriteToDraw.vflip){flip |= SDL_FLIP_VERTICAL;}

  SDL_Rect spriteRect = spriteToDraw.getRectAtIndex(index);
  SDL_Point origin = {0,0};
  SDL_RenderCopyEx(screen.renderer, 
    spriteToDraw.texture, 
    &spriteRect, 
    &onscreenRect, 0.0, 
    &origin, flip);
}

class Sprite {
  string spriteFilename;
  SDL_Texture* texture;

  bool hflip;
  bool vflip;
  bool ignoreCamera = false;

  int spriteWidth;
  int spriteHeight;
  int subimageWidth;
  int subimageHeight;
  SDL_Rect[] subimageQuads;

  this(string filename, int inpSubimageWidth = -1, int inpSubimageHeight = -1){
    spriteFilename = filename;
    texture = loadImageToTexture(filename);
    if(texture == null) {
      error.report(error.missingFile, filename);
    }
    SDL_QueryTexture(texture, null, null, &spriteWidth, &spriteHeight);
    
    /* If single sprite, then create only 1 rect in subimages */
    if(inpSubimageWidth == -1 || inpSubimageHeight == -1){
      subimageWidth = spriteWidth;
      subimageHeight = spriteHeight;
      SDL_Rect rect = { 0,0,spriteWidth,spriteHeight };
      subimageQuads ~= rect;
    }else{
      subimageWidth = inpSubimageWidth;
      subimageHeight = inpSubimageHeight;
      createSubimageQuads();
    }
  }

  ~this() {
    _log("Destroying sprite");
    SDL_DestroyTexture(texture);
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
