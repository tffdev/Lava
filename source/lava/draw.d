/**
    Contains sprite functionality and 

    The Draw module will allow u to:
        - blit sprites onto the screen at any position
        - draw filled/outlined rectangles
        - draw filled/outlined circles
        - draw lines
*/
module lava.draw;

import lava;
import std.container.array;
import std.string;

// TODO: Move this into Filesystem
public SDL_Texture* loadImageToTexture(string filename){
    SDL_Surface* imageBuffer = IMG_Load(cast(char*)filename);
    SDL_Texture* textureBuffer = SDL_CreateTextureFromSurface(screen.getRenderer(), imageBuffer);
    SDL_FreeSurface(imageBuffer);
    return textureBuffer;
}

/**
    Interfaces [directly] with the SDL rendering API to draw a sprite object onto
    the screen. 
*/
void drawSprite(Sprite spriteToDraw, int index, double x, double y) {
    SDL_Rect onscreenRect = { 
        cast(int)x - ((spriteToDraw.ignoreCamera == true)? 0 : camera.getXi()), 
        cast(int)y - ((spriteToDraw.ignoreCamera == true)? 0 : camera.getYi()), 
        spriteToDraw.subimageSize.x, 
        spriteToDraw.subimageSize.y
    };
  
    SDL_RendererFlip flip = SDL_FLIP_NONE;
    if(spriteToDraw.hflip) flip |= SDL_FLIP_HORIZONTAL;
    if(spriteToDraw.vflip) flip |= SDL_FLIP_VERTICAL;

    SDL_Rect spriteRect = spriteToDraw.__getRectAtIndex(index);
    SDL_Point origin = { 0, 0 };
    SDL_RenderCopyEx(
        screen.getRenderer(), 
        spriteToDraw.texture, 
        &spriteRect, 
        &onscreenRect, 0.0, 
        &origin, flip
    );
}

void drawRect(int x,int y,int w,int h) {
    SDL_Rect rect = SDL_Rect(x - camera.getXi(),y - camera.getYi(),w,h);
    SDL_RenderFillRect(screen.getRenderer(), &rect);
}

void setDrawColor(ubyte r, ubyte g, ubyte b, ubyte a) {
    SDL_SetRenderDrawColor(screen.getRenderer(), r, g, b, a);
}
/** 
    Class containing a texture and metadata about an image that can
    be blitted to the screen.
    Contains size, quads, mirroring data etc.
*/
class Sprite {
    string spriteFilename;
    SDL_Texture* texture;

    bool hflip;
    bool vflip;
    bool ignoreCamera = false;

    Vec2 spriteSize;
    Vec2 subimageSize;
    SDL_Rect[] subimageQuads;

    this(string filename, int subimageWidth = -1, int subimageHeight = -1){
        spriteFilename = filename;
        texture = loadImageToTexture(filename);
        if(texture == null) {
            debug logf("Cannot create image from missing file: %s", filename);
        }
        SDL_QueryTexture(texture, null, null, &spriteSize.x, &spriteSize.y);
    
        /* If single sprite, then create only 1 rect in subimages */
        if(subimageWidth == -1 || subimageHeight == -1){
            subimageSize.x = spriteSize.x;
            subimageSize.y = spriteSize.y;
            SDL_Rect rect = { 0,0,spriteSize.x,spriteSize.y };
            subimageQuads ~= rect;
        }else{
            subimageSize.x = subimageWidth;
            subimageSize.y = subimageHeight;
            __createSubimageQuads();
        }
    }

    ~this() {
        debug logf("Destroying sprite [%s]", spriteFilename);
        SDL_DestroyTexture(texture);
    }
  
    private void __createSubimageQuads() {
        int xcMax = cast(int)(spriteSize.x/subimageSize.x);
        int ycMax = cast(int)(spriteSize.y/subimageSize.y);
        for(int yc = 0; yc < ycMax; yc++){
            for(int xc = 0; xc < xcMax; xc++){
            SDL_Rect rect = { subimageSize.x*xc, subimageSize.y*yc, subimageSize.x, subimageSize.y };
            subimageQuads ~= rect;
            }
        }
    }

    private SDL_Rect __getRectAtIndex(int index){
        if(subimageQuads.length - 1 < index){
            debug logf("WARNING: SPRITE INDEX IS OUT OF BOUNDS: %d %s", index, spriteFilename);
            return subimageQuads[0];
        }
        return subimageQuads[index];
    }
}
