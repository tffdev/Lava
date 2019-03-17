module lava.game;
import lava;
import std.stdio;

private GameObject[] gameObjects;
private bool __shouldQuit = false;
private int ticksBuffer = 0;

private void shouldQuit(bool setShouldQuit){
    __shouldQuit = setShouldQuit;
}

/*
    TODO:
        THIS (UPDATE) NEEDS TO BE CONFIGURABLE BY THE USER.
    
*/
public void update() {
    int ticksCurrent = SDL_GetTicks();
    if(ticksBuffer + 1000/60 < ticksCurrent){
        int presetp = SDL_GetTicks();
        ticksBuffer = ticksCurrent;

        // event management
        SDL_Event e;
        bool quit = false;
        while(SDL_PollEvent(&e)){
            handleEvent(e, &quit);
        }
        /*
            TODO: Make all of these render to different surfaces
            then merge them depending on DEPTH of each render.
        */
        // main clear->update->draw->present loop
        screen.clear();
        backgrounds.drawBackgrounds();
        maps.drawMap();
        game.stepAll();
        screen.copyPrescreenToBuffer();
        text.outputDebugText();
        screen.present();
    
        // finalising and clearing data for that frame
        keyboard.clearPressedKeys();
        if(quit) shouldQuit(true);
    }
    SDL_Delay(2);
}

/* Base Object template */
class GameObject {
    double x;
    double y;
    void step(){};
}

private void stepAll() {
    /* update and draw stuff */
    foreach(object; gameObjects) {
        object.step();
    }
}

private bool handleEvent(SDL_Event e, bool* quit){
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
    }
    return false;
}

public void quit(){
    TTF_Quit();
    screen.destroy();
    SDL_Quit();
}

public void addObject(GameObject obj){
    gameObjects ~= obj;
}

public bool shouldExitGameloop(){
    return __shouldQuit;
}


