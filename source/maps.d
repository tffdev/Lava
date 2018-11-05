module maps;
import std.stdio;
import std.json;
import std.file;

import assets;
import screen;

Sprite tilemap_sprite;

int[] map_tiles;
int map_width;
int map_height;
int tile_width;
int tile_height;

void load_map(string mapfile, string imagefile)
{
  map_data = std.json.parseJSON(std.file.readText(mapfile));
  map_width = cast(int)map_data["width"].integer;
  map_height = cast(int)map_data["height"].integer;
  tile_width = cast(int)map_data["tilewidth"].integer;
  tile_height = cast(int)map_data["tileheight"].integer;
  tilemap_sprite = new Sprite(imagefile, 16, 16);
  for(int i=0;i<map_width*map_height;i++){
    map_tiles ~= cast(int)map_data["layers"][0]["data"][i].integer - 1;
  }
}

void draw_map() {
  for(int x=0;x<map_width;x++){
    for(int y=0;y<map_height;y++){
      int tile = map_tiles[x%map_width + y*map_width];
      if(tile!=-1){
        screen.draw_sprite(tilemap_sprite, tile, 
          x*tile_width, y*tile_height);
      }
    }
  }
}