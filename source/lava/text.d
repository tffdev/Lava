module text;

import std.string;
import std.container.array;
import lava;

TTF_Font* fontm5x7;

debug {
    Sprite debugTextSprite;
    Array!(string) debugTextBuffer;
    immutable DEBUGALPHABET = " !+#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~";
}

/**
    Generic (non-generalised) TTF text rendering function.
    This function does not buffer the text, but draws directly onto the renderer.
    TODO: Custom fonts
*/
public void drawText(string textToDraw, int x, int y){
    if(!fontm5x7){
        fontm5x7 = TTF_OpenFont("source/lava/resources/m5x7.ttf", 15);
    }
    SDL_Color color = { 0, 0, 0 };
    SDL_Surface* surface = TTF_RenderText_Solid(fontm5x7, cast(char*)textToDraw, color);
    SDL_Texture* fontTexture = SDL_CreateTextureFromSurface(screen.getRenderer(), surface);
    SDL_Rect a = { 0, 0, surface.w, surface.h };
    SDL_Rect b = { x, y, surface.w, surface.h };
    SDL_FreeSurface(surface);
    SDL_RenderCopy(screen.getRenderer(),fontTexture,&a,&b);
    SDL_DestroyTexture(fontTexture);
}

/** 
    Inserts text into a buffer to be displayed during runtime.
    Used for easily monitoring variables in realtime.
*/

public void drawDebugText(string input) {
    debug { 
        if(!debugTextSprite){
            debugTextSprite = new Sprite("source/lava/resources/debugFont.gif", 12, 13);
            debugTextSprite.ignoreCamera = true;
        }
        debugTextBuffer ~= input;
    }
}

/**
    Draws all debug text in the buffer and then clears the buffer.
    This is used after the everything has been rendered
*/
public void outputDebugText() {
    debug {
        for (int row = 0; row < debugTextBuffer.length(); row++){
            string text = debugTextBuffer[row];
            for(int i=0; i<text.length;i++){
                char letter = text[i];
                draw.drawSprite(debugTextSprite, 
                    cast(int)indexOf(DEBUGALPHABET, letter), i*9, 13*row);
            }
        }
        debugTextBuffer.clear();
    }
}


