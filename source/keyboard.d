module keyboard;
import std.stdio;
import std.conv;
import derelict.sdl2.sdl;

private bool[string] keys_down;
private bool[string] keys_pressed;

void pass_pressed_key(SDL_Keysym input_key){
	keys_down[to!string(SDL_GetKeyName(input_key.sym))] = true;
	keys_pressed[to!string(SDL_GetKeyName(input_key.sym))] = true;
}
void pass_lifted_key(SDL_Keysym input_key){
	keys_down[to!string(SDL_GetKeyName(input_key.sym))] = false;
}
bool is_down(string key_name){
	if(key_name in keys_down && keys_down[key_name]) {
		return true;
	}else{
		return false;
	}
}
bool is_pressed(string key_name){
	if(key_name in keys_pressed && keys_pressed[key_name]) {
		return true;
	}else{
		return false;
	}
}
void clear_pressed_keys(){
	keys_pressed.clear();
}