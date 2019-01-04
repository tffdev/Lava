module camera;
import lava;
import std.algorithm;

private Vec2d  pos;
private bool   __canMoveOutsideMap = false;
private bool   __lerp = true;
private double __lerpAmount = 0.3;

// let external objects manipulate camera position
void setPosition(double x, double y){
    pos.x = x;
    pos.y = y;

    if(!__canMoveOutsideMap) {
        pos.x = clamp(pos.x, 0, maps.getMapWidth() - screen.getWidth());
        pos.y = clamp(pos.y, 0, maps.getMapHeight() - screen.getHeight());
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
    pos.x = x;
}
void setY(double y){
    pos.y = y;
}
double getX() {
    return pos.x;
}
double getY() {
    return pos.y;
}
int getXi() {
    return cast(int)pos.x;
}
int getYi() {
    return cast(int)pos.y;
}
