module lava.maps;
import std.stdio;
import std.json;
import std.file;
import lava;

Sprite tilemapSprite;

struct MapLayer {
    int[] data;
    bool visible;
};

private MapLayer[] mapLayers;
private Vec2 mapSize;
private Vec2 tileSize;
private bool mapLoaded = false;

int getMapWidth() {
   return mapSize.x * tileSize.x; 
}

int getMapHeight() {
   return mapSize.y * tileSize.y; 
}

void loadMap(string mapFileName, string imageFileName){
    mapLoaded = true;
    string mapfileOutput = std.file.readText(mapFileName);
    JSONValue mapData = std.json.parseJSON(mapfileOutput);
    mapSize.x = cast(int) mapData["width"].integer;
    mapSize.y = cast(int) mapData["height"].integer;
    tileSize.x = cast(int) mapData["tilewidth"].integer;
    tileSize.y = cast(int) mapData["tileheight"].integer;
    tilemapSprite = new Sprite(imageFileName, 16, 16);

    // Making this bitch empty, there's no slices anywhere, are there?
    mapLayers = [];

    // Push all the map tile values into a 2D array (NB: layers, then tiles,
    // not X and Y coordinates of tiles).
    for(int i = 0; i < mapData["layers"].array.length; i++){
        MapLayer buffer;
        foreach(JSONValue tile; mapData["layers"][i]["data"].array){
            buffer.data ~= cast(int)tile.integer;
        }
        buffer.visible = (mapData["layers"][i]["visible"].boolean) ? true : false;
        mapLayers ~= buffer;
    }
}

bool __checkMapValid() {
    return mapLoaded && mapSize.x > 0 && mapSize.y > 0 && tileSize.x > 0 && tileSize.y > 0;
}

void drawMap() {
    if(mapLoaded){
        for(int i = 0; i < mapLayers.length; i++ ){
            drawMapLayer(i);
        }
    }
}

void drawMapLayer(int layer){
    if(!mapLayers[layer].visible) return;
    for(int x=0; x < mapSize.x; x++){
        for(int y=0; y < mapSize.y; y++){
            int tile = mapLayers[layer].data[x % mapSize.x + y * mapSize.x];
            if(tile != 0){
                draw.drawSprite(tilemapSprite, tile - 1, x * tileSize.x, y * tileSize.y);
            }
        }
    }
}

int getTileAt(int x, int y, int layer){
    int tileval = (x / tileSize.x) % mapSize.x + (y / tileSize.y) * mapSize.x;
    if(tileval<0 || tileval > mapLayers[layer].data.length || x < 0 || y < 0 
        || x > mapSize.x*tileSize.x || y > mapSize.y * tileSize.y){
        return -1;
    }
    return mapLayers[layer].data[tileval];
}
