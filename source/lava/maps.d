module maps;
import std.stdio;
import std.json;
import std.file;

import assets;
import screen;

Sprite tilemapSprite;

int[] mapTiles;
int mapWidth;
int mapHeight;
int tileWidth;
int tileHeight;

void loadMap(string mapfile, string imagefile)
{
  string mapfileOutput = std.file.readText(mapfile);
  JSONValue mapData = std.json.parseJSON(mapfileOutput);
  mapWidth = cast(int)mapData["width"].integer;
  mapHeight = cast(int)mapData["height"].integer;
  tileWidth = cast(int)mapData["tilewidth"].integer;
  tileHeight = cast(int)mapData["tileheight"].integer;
  tilemapSprite = new Sprite(imagefile, 16, 16);
  for(int i=0;i<mapWidth*mapHeight;i++){
    mapTiles ~= cast(int)mapData["layers"][0]["data"][i].integer - 1;
  }
}

void drawMap() {
  for(int x=0;x<mapWidth;x++){
    for(int y=0;y<mapHeight;y++){
      int tile = mapTiles[x%mapWidth + y*mapWidth];
      if(tile!=-1){
        assets.drawSprite(tilemapSprite, tile, 
          x*tileWidth, y*tileHeight);
      }
    }
  }
}

int getTileAt(int x, int y){
  int tileval = (x/tileWidth)%mapWidth + (y/tileHeight)*mapWidth;
  if(tileval<0 || tileval > mapTiles.length || x < 0 || y < 0 
    || x > mapWidth*tileWidth || y > mapHeight * tileHeight){
    return -1;
  }
  return mapTiles[tileval];
}