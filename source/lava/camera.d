module camera;

import lava;

double cameraX = 0;
double cameraY = 0;

void setPosition(double x, double y){
  cameraX = x;
  cameraY = y;
}
void setPositionX(double x){
  cameraX = x;
}
void setPositionY(double y){
  cameraY = y;
}
int getPositionX() {
  return cast(int)cameraX;
}

int getPositionY() {
  return cast(int)cameraY;
}