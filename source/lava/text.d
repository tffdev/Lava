module text;

import std.string;
import std.container.array;
import derelict.sdl2.sdl;
import derelict.sdl2.ttf;
import lava;

TTF_Font* fontm5x7;

Sprite debugTextSprite;
Array!(string) debugTextBuffer;

immutable DEBUGALPHABET = " !+#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~";

public void drawText(string textToDraw, int x, int y){
  if(!fontm5x7){
    fontm5x7 = TTF_OpenFont("source/lava/resources/m5x7.ttf", 15);
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
    debugTextSprite = new Sprite("source/lava/resources/debugFont.gif", 12, 13);
    debugTextSprite.ignoreCamera = true;
  }
  debugTextBuffer ~= input;
}

public void outputDebugText() {
  for (int row = 0; row < debugTextBuffer.length(); row++){
    string text = debugTextBuffer[row];
    for(int i=0; i<text.length;i++){
      char letter = text[i];
      assets.drawSprite(debugTextSprite, 
        cast(int)indexOf(DEBUGALPHABET, letter), 5+i*9, 5+15*row);
    }
  }
  debugTextBuffer.clear();
}