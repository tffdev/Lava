module assets;

import std.stdio;
import std.container.array;
import std.string;
import derelict.sdl2.sdl;
import derelict.sdl2.image;
import screen;
import error;

Sprite debugTextSprite;
Array!(string) debugTextBuffer;

immutable DEBUGALPHABET = " !+#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~";

private SDL_Texture* loadImageToTexture(string filename){
  SDL_Surface* imageBuffer = IMG_Load(cast(char*)filename);
  SDL_Texture* textureBuffer = SDL_CreateTextureFromSurface(screen.renderer, imageBuffer);
  SDL_FreeSurface(imageBuffer);
  return textureBuffer;
}

public void drawDebugText(string input) {
  if(!debugTextSprite){
    debugTextSprite = new Sprite("source/debugFont.gif", 12, 13);
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
