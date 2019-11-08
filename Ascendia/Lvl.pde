boolean transition = false;
float transitionFrame = 0;
float transitionLength = 30;
String transitionDir = "RIGHT";

void startLevel(int lv, String position){
  level = lv;
  
  //making entrance position equal map's
  if(position.equals("TOP")){
    player_ix_init = maps[level].top_ix;
    player_iy_init = maps[level].top_iy;
  }
  else if(position.equals("BOTTOM")){
    player_ix_init = maps[level].bottom_ix;
    player_iy_init = maps[level].bottom_iy;
  }
  else if(position.equals("LEFT")){
    player_ix_init = maps[level].left_ix;
    player_iy_init = maps[level].left_iy;
  }
  else if(position.equals("RIGHT")){
    player_ix_init = maps[level].right_ix;
    player_iy_init = maps[level].right_iy;
  }
  
  //load the map
  map_load();
  map_loaded = true;
  
  //set mode to gameplay
  menu = 1;
}

void nextLevel(String dir){
  
  int mx = maps[level].mx;
  int my = maps[level].my;
  int lv;
  
  String toDir = "LEFT";
   
  
       if(dir.equals("UP")   ){ my--; toDir = "DOWN"; }
  else if(dir.equals("DOWN") ){ my++; toDir = "UP";   }
  else if(dir.equals("LEFT") ){ mx--; toDir = "RIGHT";}
  else if(dir.equals("RIGHT")){ mx++; toDir = "LEFT" ;}
  
  transitionDir = dir;
  
  boolean found = false;
  int i = 0;
  while(!found){
    boolean matchX = maps[i].mx == mx;
    boolean matchY = maps[i].my == my;
    if( matchX && matchY ){
      found = true;
      
    }else{
      i++;
      if(i >= maps.length){
        found = true;
        i = 0;
      }
    }
  }
  lv = i;
  
  
  transition = true;
  if(transitionFrame >= transitionLength/2){
    player.justSpawned = true;
    startLevel(lv,toDir);
    
  }
  
}

void transition(){
  if(transition){
    fill(0,200);noStroke();
    float transitionHalf = transitionLength/2;
    if(transitionFrame < transitionHalf){
      float theta = map(transitionFrame,0,transitionHalf,0,PI/2);
      float value = sin(theta);
      
      float posx = -margin_x;
      float posy = -margin_y;
      float wx = width;
      float wy = height;
      
           if(transitionDir.equals("UP"))   { wy   = map(value, 0, 1, 0, height);   }
      else if(transitionDir.equals("DOWN")) { posy = map(value, 0, 1, height-margin_y, 0-margin_y) ; 
                                              wy   = height-margin_y - posy; }
      else if(transitionDir.equals("RIGHT")){ posx = map(value,0,1,width-margin_x, 0-margin_x);
                                              wx   = width-margin_x - posx; }
      else if(transitionDir.equals("LEFT")) { wx   = map(value, 0, 1, 0, width); }
      rect(posx,posy,wx,wy);
    }
    
    
    if((transitionLength > transitionFrame)&&(transitionFrame >= transitionHalf)){
      float theta = map(transitionFrame,transitionHalf,transitionLength,0,PI/2);
      float value = sin(theta);
      
      float posx = -margin_x;
      float posy = -margin_y;
      float wx = width;
      float wy = height;
           if(transitionDir.equals("DOWN")) { wy   = map(value, 1, 0, 0, height);   }
      else if(transitionDir.equals("UP"))   { posy = map(value, 1, 0, height-margin_y, 0-margin_y) ; 
                                              wy   = height-margin_y - posy; }
      else if(transitionDir.equals("RIGHT")){ wx   = map(value, 1, 0, 0, width); }
      else if(transitionDir.equals("LEFT")) { posx = map(value, 1, 0,width-margin_x, 0-margin_x);
                                              wx   = width-margin_x - posx; }
      rect(posx,posy,wx,wy);
      
    }
    transitionFrame++;
    if(transitionFrame > transitionLength){
      transition = false;
    }
  }
}



void map_load(){
  
  
  for(int i = 0; i < n_grid_x; i++){
    for(int j = 0; j < n_grid_y; j++){
      String type = maps[level].map.getString(j,i);
      if (!type.equals("0")){
        
        objects[i][j] = new Object(i, j, type);
      } else {
        objects[i][j] = null;
      }
      
      //createutton
      String command = "objectClicked";
      String commandDetail = str(i) + "," + str(j);
      fieldbuttons[i][j] = new Button(i, j, gridsize, gridsize, command, commandDetail, desertback, false);
    }
  }

  //objects[player_ix_init][player_iy_init] = new Object(player_ix_init, player_iy_init, "Player");
  player.ix = player_ix_init;
  player.iy = player_iy_init;
  
  
  
}

void mapBackground(){
  int amount_x = ceil(margin_x/gridsize);
  int amount_y = ceil(margin_y/gridsize);
  
  fill(254,211,133); noStroke();
  rect(-amount_x*gridsize, - amount_y*gridsize, gridsize * (n_grid_x + 2*amount_x), gridsize * (n_grid_y + 2*amount_y));
  
  for( int i = 0; i < amount_x; i++){
    float posx  =  n_grid_x * gridsize + i * gridsize; 
    float pospx = - gridsize - (i * gridsize);
    image(wall      , posx , -gridsize                , gridsize, 2*gridsize);
    image(wallBottom, posx , (n_grid_y - 1) * gridsize, gridsize, 2*gridsize);
    image(wall      , pospx, -gridsize                , gridsize, 2*gridsize);
    image(wallBottom, pospx, (n_grid_y - 1) * gridsize, gridsize, 2*gridsize);
  }
  
  fill(0,170); noStroke();
  rect(-amount_x*gridsize, - amount_y*gridsize, gridsize * (n_grid_x + 2*amount_x), gridsize * (n_grid_y + 2*amount_y));
}
