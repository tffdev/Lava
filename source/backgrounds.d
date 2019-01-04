module backgrounds;

import lava;
import std.math;
import std.stdio;
import std.format;

Background[5] backgroundImages;

/**
    Sets a background layer up to a maximum of 5 layers. 
    "parallax" parameter: 0 means frontmost (fast movement), 1 means backmost (slow/no movement)
*/
void setBackground(int index, string filename, double parallax = 0, int xoffset = 0, int yoffset = 0) {
    // Frees memory upon overwrite of existing background
    if(backgroundImages[index] !is null) {
        backgroundImages[index].destroy();
    }
    backgroundImages[index] = new Background(filename, parallax, xoffset, yoffset);
}

void drawBackgrounds() {
    foreach(bg; backgroundImages) {
        if(bg !is null){
            int i = cast(int)((camera.getX() * (1 - bg.parallax)) / bg.image.spriteSize.x);
            double bgX = i*bg.image.spriteSize.x + bg.parallax * camera.getX();
            while(bgX - screen.getWidth() < camera.getX() + screen.getWidth()){
                assets.drawSprite(bg.image, 0, bgX - screen.getWidth() + bg.offset.x, camera.getY() * bg.parallax + bg.offset.y);
                bgX += bg.image.spriteSize.x;
            }
        }
    }
}

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
