module assets;

import std.stdio;
import std.container.array;
import std.string;

import derelict.sdl2.sdl;
import derelict.sdl2.image;

import screen;

Sprite debugTextSprite;
Array!(string) debugTextBuffer;

immutable DEBUGALPHABET = " !+#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~";

private SDL_Texture* loadImageToTexture(string filename){
  SDL_Surface* imageBuffer = IMG_Load(cast(char*)filename);
  SDL_Texture* textureBuffer = SDL_CreateTextureFromSurface(screen.renderer, imageBuffer);
  SDL_FreeSurface(imageBuffer);
  return textureBuffer;
}

public void draw_debug_text(string input) {
  if(!debugTextSprite){
    debugTextSprite = new Sprite("source/debug_font.gif", 12, 13);
  }
  debugTextBuffer ~= input;
}

public void output_debug_text() {
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
  SDL_Texture* texture;

  int spriteWidth;
  int spriteHeight;
  int subimageWidth;
  int subimage_height;
  SDL_Rect[] subimage_quads;

  this(string filename, int inpSubimageWidth, int inp_subimage_height){
    texture = loadImageToTexture(filename);
    SDL_QueryTexture(texture, null, null, &spriteWidth, &spriteHeight);

    subimageWidth = inpSubimageWidth;
    subimage_height = inpSubimage_height;
    createSubimageQuads();
  }

  void createSubimageQuads() {
    int xc_max = cast(int)(spriteWidth/subimageWidth);
    int yc_max = cast(int)(spriteHeight/subimage_height);
    for(int yc = 0; yc < yc_max; yc++){
      for(int xc = 0; xc < xc_max; xc++){
        SDL_Rect rect = { subimageWidth*xc, subimage_height*yc, subimageWidth, subimage_height };
        subimage_quads ~= rect;
      }
    }
  }

  SDL_Rect get_rect_at_index(int index){
    return subimage_quads[index];
  }
}
