/**
    The Screen module contains everything that 
*/  
module lava.screen;
import std.stdio;
import std.algorithm;
import lava;

private SDL_Window* window;
private SDL_Renderer* renderer;
private SDL_Texture* prescreenTexture;

private Vec2 windowSize;

private int renderScale;
private double width;
private double height;

void init(string windowTitle, int inpWindowXsize, 
    int inpWindowYsize, int inpRenderScale, bool resizable = true) {
    /*
     - Load SDL2
     - set window params
     - create window
     - create renderer
     - create render buffer
     */
    
    loadDerelict();
    
    windowSize.x = inpWindowXsize * inpRenderScale;
    windowSize.y = inpWindowYsize * inpRenderScale;
    renderScale = inpRenderScale;
    width = inpWindowXsize;
    height = inpWindowYsize;
    
    uint windowFlags = SDL_WINDOW_SHOWN;
    
    if (resizable) windowFlags |= SDL_WINDOW_RESIZABLE;
    
    window = SDL_CreateWindow(cast(char*)windowTitle, SDL_WINDOWPOS_UNDEFINED, 
        SDL_WINDOWPOS_UNDEFINED, windowSize.x, windowSize.y, windowFlags);
        
    renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_PRESENTVSYNC);
    
    prescreenTexture = SDL_CreateTexture(renderer, SDL_PIXELFORMAT_RGBA8888, 
        SDL_TEXTUREACCESS_TARGET, windowSize.x/inpRenderScale, windowSize.y/inpRenderScale);
        
    SDL_SetRenderTarget(renderer, prescreenTexture);
    SDL_AddEventWatch(&eventWindow, window);
    SDL_SetRenderDrawBlendMode(renderer, SDL_BLENDMODE_BLEND);
}

private void loadDerelict(){
    DerelictSDL2.load();
    DerelictSDL2Image.load();
    DerelictSDL2ttf.load();
    TTF_Init();
}

void clear(){
    SDL_SetRenderTarget(renderer, null);
    SDL_SetRenderDrawColor(screen.renderer, 0, 0, 0, 255);
    SDL_RenderClear(screen.renderer);
    SDL_SetRenderTarget(renderer, prescreenTexture);
    SDL_SetRenderDrawColor(screen.renderer, 255, 255, 255, 255);
    SDL_RenderClear(screen.renderer);
}

void copyPrescreenToBuffer(){
    int w, h;
    SDL_GetWindowSize(window, &w, &h);

    /*
     - Calculates the size and position on screen depending on the window's current state.
     - Game --(renders to)--> PrescreenBuffer --(renders to)--> Window Renderer [active when render target is null].
     - Generates an SDL_Rect representing the geometry of the Game window. 
     */
    SDL_Rect prescreenRect = { 0, 0, windowSize.x/renderScale, windowSize.y/renderScale };

    double sizex = windowSize.x/renderScale;
    double sixey = windowSize.y/renderScale;

    double wScale = min(w/sizex, h/sixey);
    double ratio = sizex/sixey; 
    int xoffset = cast(int)max(((w - h*ratio)/2), 0);
    int yoffset = cast(int)max(((h - w/ratio)/2), 0);

    SDL_Rect windowRect = { xoffset, yoffset, 
        cast(int)((windowSize.x/renderScale)*wScale), cast(int)((windowSize.y/renderScale)*wScale) };

    // Display on screen
    SDL_SetRenderTarget(renderer, null);
    SDL_RenderCopy(renderer, prescreenTexture, &prescreenRect, &windowRect);
}

void present(){
    SDL_RenderPresent(screen.renderer);
    SDL_SetRenderTarget(renderer, prescreenTexture);
}

void setWindowTitle(string title){
    SDL_SetWindowTitle(window, cast(char*)title);
}

void destroy(){
    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(window);
}

double getWidth() {
    return width;
}

double getHeight() {
    return height;
}
SDL_Renderer* getRenderer() {
    return renderer;
}
// Called when window is modified
extern (C) int eventWindow(void* data, SDL_Event* event) nothrow {
    return 0;
}
