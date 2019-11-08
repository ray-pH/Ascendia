int level = 0;
boolean map_loaded = false;

Player player = new Player(0,0,0);
int player_ix_init = 0;
int player_iy_init = 0;

void game(){ 
  
  // if the map is not loaded yt, load the map
  if(!map_loaded){
    map_load();
    map_loaded = true;
  }  
  
  mapBackground();
  updateFieldButton();  
  
  //show all button
  for( Button[] bts : fieldbuttons){
    for( Button b : bts){
      b.show();
    }
  }
  guide_grid();
  guide_cursor();
  
  
  //show all objects
  for( Object[] obs : objects){
    for( Object o : obs){
      if ( o != null ){
        o.show();
      }
    }
  }
  
  player.show();
  
  boolean popUp = false;
  for( Object[] obs : objects){
    for( Object o : obs){
      if( o != null ){
      boolean isSelected = o.selected();
      if ( isSelected ){
        popUp = true;
      }
      }
    }
  }
  if(popUp){
    popUpMenu();
  }
 
 
 message();
  
}
