module game;
import lava;
import std.stdio;
import std.conv;

private GameObject[] gameObjects;
private bool __shouldQuit = false;
private int ticksBuffer = 0;

bool shouldQuit(){
    return __shouldQuit;
}

void quitUpdateLoop(){
    __shouldQuit = true;
}

void update(void delegate() _userDefinedLoopFunc) {
    int ticksCurrent = SDL_GetTicks();
    if(ticksBuffer + 1000/60 < ticksCurrent){
        int presetp = SDL_GetTicks();
        ticksBuffer = ticksCurrent;
        SDL_Event e;
        bool quit = false;
        while(SDL_PollEvent(&e)){
            handleEvent(e, &quit);
        }

        _userDefinedLoopFunc();
        
        keyboard.clearPressedKeys();
        if(quit) quitUpdateLoop();
    }
    SDL_Delay(1);
}

/* Base Object template */
class GameObject {
    double x;
    double y;
    void step(){};
}

void stepAll() {
    /* update and draw stuff */
    foreach(object; gameObjects) {
        object.step();
    }
}

void addObject(GameObject obj){
    gameObjects ~= obj;
}

bool handleEvent(SDL_Event e, bool* quit){
    switch(e.type){
        case SDL_QUIT: *quit = true; break;
        case SDL_KEYDOWN: if(e.key.repeat == 0) keyboard.passPressedKey(e.key.keysym);
        break;
        case SDL_KEYUP: if(e.key.repeat == 0) keyboard.passLiftedKey(e.key.keysym);
        break;
        case SDL_WINDOWEVENT:
        if(e.window.event == SDL_WINDOWEVENT_RESIZED){
            debug logf("Window %d size changed to %dx%d", e.window.windowID, e.window.data1, e.window.data2);
        }
        break;
        default: 
            
        break;
    }
    return false;
}

public void quit(){
    printf("Quitting");
    TTF_Quit();
    screen.destroy();
    SDL_Quit();
}
