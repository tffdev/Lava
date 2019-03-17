module lava.backgrounds;

import lava;
import std.math;
import std.stdio;
import std.format;

Background[5] backgroundImages;

/**
    Sets a background layer up to a maximum of 5 layers. 
    "parallax" parameter: 0 means frontmost (fast movement), 1 means backmost (slow/no movement)
*/
void set(int index, string filename, double parallax = 0, int xoffset = 0, int yoffset = 0) {
    // Frees memory upon overwrite of existing background
    if(backgroundImages[index] !is null) {
        backgroundImages[index].destroy();
    }
    backgroundImages[index] = new Background(filename, parallax, xoffset, yoffset);
}

void drawBackgrounds() {
    foreach(int i; 0..4) {
        drawBackground(i);
    }
}

/**
    TODO: This algorithm is fuckin wrong
    ====================================
    
    Draws a background repeated along the X and Y axis relative to camera
    position, parallax, and screenspace boundries. Will seem to repeat
    infinitely, but is only drawn if background would be on screen.
*/
void drawBackground(int index){
    Background bg = backgroundImages[index];
    if(bg !is null){
        int i = cast(int)((camera.getX() * (1 - bg.parallax)) / bg.image.spriteSize.x);
        int bgX = cast(int)(i*bg.image.spriteSize.x + bg.parallax * camera.getX());
        while(bgX - screen.getWidth() < camera.getX() + screen.getWidth()){
            int bgY = cast(int)(i*bg.image.spriteSize.y + bg.parallax * camera.getY());
            while(bgY - screen.getHeight() < camera.getY() + screen.getHeight()){
                draw.drawSprite(bg.image, 0, 
                    bgX - screen.getWidth() + bg.offset.x, 
                    bgY - screen.getHeight() + bg.offset.y
                );
                bgY += bg.image.spriteSize.y;
            }
            bgX += bg.image.spriteSize.x;
        }
    }
}

/**
    A structure that contains data for a background: 
    a sprite (the image), a parallax value (how "far away" 
    the background is wrt camera movement) and offset data.
*/
class Background {
    Sprite image;
    double parallax;
    Vec2 offset;
    
    this(string filename, double inpParallax, int xoffset, int yoffset) {
        image = new Sprite(filename);
        parallax = inpParallax;
        offset.y = yoffset;
    }

    ~this() {
        image.destroy();
    }
}
