module lava.camera;
import lava;
import std.algorithm;

private Vec2d  __pos = {0, 0};
private bool   __canMoveOutsideMap = false;
private bool   __lerp = true;
private double __lerpAmount = 0.3;

// let external objects manipulate camera position
void setPosition(double x, double y){
    __pos.x = x;
    __pos.y = y;

    if(!__canMoveOutsideMap) {
        __pos.x = clamp(__pos.x, 0, maps.getMapWidth() - screen.getWidth());
        __pos.y = clamp(__pos.y, 0, maps.getMapHeight() - screen.getHeight());
    }
}

// getter/setter for allowing camera to go outside map boundries
bool canMoveOutsideMap() {
    return __canMoveOutsideMap;
}
void canMoveOutsideMap(bool canMove) {
    __canMoveOutsideMap = canMove;
}

// geometric getter/setters
void setX(double x){
    __pos.x = x;
}
void setY(double y){
    __pos.y = y;
}
double getX() {
    return __pos.x;
}
double getY() {
    return __pos.y;
}
int getXi() {
    return cast(int)__pos.x;
}
int getYi() {
    return cast(int)__pos.y;
}
