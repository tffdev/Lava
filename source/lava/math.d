module lava.math;

struct Vec2 {
    int x;
    int y;
}

struct Vec2d {
    double x;
    double y;
}
    
double lerp(double a, double b, double f) {
    return a + f * (b - a);     
}
