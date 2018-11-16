module backgrounds;
import lava;
import std.math;
import std.stdio;
import std.format;
Background[5] backgroundImages;

void setBackground(int index, string filename, double parallax = 0, int yoffset = 0) {
  // Frees memory upon overwrite of existing background
  if(backgroundImages[index] !is null) {
    backgroundImages[index].destroy();
  }
  backgroundImages[index] = new Background(filename, parallax, yoffset);
}

void drawBackgrounds() {
  foreach(bg; backgroundImages) {
    if(bg !is null){
      int i = cast(int)((camera.cameraX * (1 - bg.parallax)) / bg.image.spriteWidth);
      double bgX = i*bg.image.spriteWidth + bg.parallax * camera.cameraX;
      while(bgX - screen.width < camera.cameraX + screen.width){
        assets.drawSprite(bg.image, 0, bgX - screen.width, camera.cameraY*bg.parallax + bg.yoffset);
        bgX += bg.image.spriteWidth;
      }
    }
  }
}

class Background {
  Sprite image;
  double parallax;
  int yoffset;
  this(string filename, double inpParallax, int yoffset) {
    image = new Sprite(filename);
    parallax = inpParallax;
  }
  ~this() {
    image.destroy();
  }
}