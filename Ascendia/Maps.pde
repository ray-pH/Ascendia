Map[] maps = new Map[2];
Map emptyMap;

void maps_init(){
  emptyMap = new Map("mapnull.csv", 0, 0);
  maps[0] = new Map("map0.csv", 0, 0);
  maps[1] = new Map("map1.csv", 1, 0); 
}

class Map {
  Table map;
  int mx, my;
  int top_ix, top_iy;
  int bottom_ix, bottom_iy;
  int left_ix, left_iy;
  int right_ix, right_iy;
  
  Map(String smap, int mx, int my){
    smap = "maps/" + smap; 
    this.map = loadTable(smap);
    this.mx = mx;
    this.my = my;
    
     //getting entrance coordinate
    this.top_ix    = int(map.getString( n_grid_y + 0, 1));
    this.top_iy    = int(map.getString( n_grid_y + 0, 2));
    this.bottom_ix = int(map.getString( n_grid_y + 1, 1));
    this.bottom_iy = int(map.getString( n_grid_y + 1, 2));
    this.left_ix   = int(map.getString( n_grid_y + 2, 1));
    this.left_iy   = int(map.getString( n_grid_y + 2, 2));
    this.right_ix  = int(map.getString( n_grid_y + 3, 1));
    this.right_iy  = int(map.getString( n_grid_y + 3, 2));
    
  }
  
  
  
}
