import std.stdio;
import std.format;
import std.algorithm;
import lava;
import backgrounds;


void main(){
    debug log("DEBUG MODE ACTIVE");

    screen.init("Lava Test", 320, 240, 2, true);    

    // START ROOM 1 CREATION
    maps.loadMap("maps/map_1.json","images/tiles.png");
    game.addObject(new Girl(50, 50));
    setBackground(3,"images/bg91.png", 0.3, 0, 40);
    setBackground(2,"images/bg92.png", 0.85);
    setBackground(1,"images/bg93.png", 0.96);
    setBackground(0,"images/bg94.png", 1);
    // END ROOM 1 CREATION

    void loopfunc() {
        screen.clear();
        backgrounds.drawBackgrounds();
        maps.drawMap();
        game.stepAll();
        screen.copyPrescreenToBuffer();
        text.outputDebugText();
        screen.present();
    }

    while(!game.shouldQuit()){
        game.update(&loopfunc);
    }

    game.quit();
}

class Girl : GameObject 
{
    private Vec2d vel = { 0, 0 };
    private bool onground;
    private double maxmovespeed = 2;
    private double accelspeed = 1;
    private double spriteIndex = 0;
    private Sprite mainSprite;

    enum Animation : int[] {
        walkUp = [38,39,40,41,42,43,45,46]
    };

    private Animation currentAnimation = Animation.walkUp;
    private double animationSpeed = 0.2;

    this(int ix, int iy)
    {
        x = ix;
        y = iy;
        mainSprite = new Sprite("images/player.png", 32, 32);
    }

    override void step()
    {
        spriteIndex = spriteIndex + animationSpeed;
        if(spriteIndex >= currentAnimation.length) spriteIndex=0;
        text.drawDebugText(format("Girl's sprite index: %f", spriteIndex));
        
        drawText("This is some TTF text! Hello world!", 10, 120);
        
        if(keyboard.isDown("Left"))    {xvel -= accelspeed; mainSprite.hflip = false;}
        if(keyboard.isDown("Right")) {xvel += accelspeed; mainSprite.hflip = true;}
        if(keyboard.isDown("A") && onground) {y-=1; yvel = -5;}
        
        applyPhysics();

        text.drawDebugText(format("girl x, y: %s %s", x, y));
        text.drawDebugText(format("tile at x, y: %s", getTileAt(cast(int)x+16, cast(int)y+32)));
        
        if(keyboard.isDown("R")) {setBackground(0,"images/bg91.png");}
        if(keyboard.isDown("R")) {setBackground(0,"images/bg92.png");}

        draw.drawSprite(mainSprite, currentAnimation[cast(int)spriteIndex], x, y);
        camera.setPosition(x - 100, y - 150);
    }

    void applyPhysics() {
        /* Horizontal movement */
        xvel = clamp(xvel,-maxmovespeed,maxmovespeed);
        x += xvel;
        xvel /= 1.5;

        int tile = getTileAt(cast(int)x+16, cast(int)y+32);
        /* Gravity and vertical cols */
        if(tile == -1){
            yvel += 0.3;
            yvel = clamp(yvel,-10, 10);
            y += yvel;
            onground = false;
        }

        while(getTileAt(cast(int)x+16, cast(int)y+32) != -1){
            yvel = 0;
            y-=1;
            onground = true;
        }
        y+=1;
    }
}
