int menu;
String ButtonCommand;
String ButtonCommandDetail;;
void setup(){
  
  //size(displayWidth,displayHeight,P2D);
  //orientation(LANDSCAPE);
  
  size(1060,600, P2D);
  surface.setResizable(true);
  
  textAlign(CENTER, CENTER);
  
  frameRate(60);
  menu = 0;
  abilities_init();
  maps_init();
  screen_ratio();
  asset_init();
  load_font();
  
  //debug
  //setButtonCommand("gamestart");
  //setButtonCommand("cutstart");
  //setButtonCommandDetail("0");
}

/*  menu 0 : mainmenu
         1 : game
*/


void draw(){
  translate(margin_x,margin_y);
  background(10);
  screen_ratio();
  if(ButtonCommand != null){
  listenButton();
  }
  if (menu == 0) { mainmenu(); }
  if (menu == 1) { game(); }
  if (menu == 2) { cutscenes(); }
  transition();
}


//debugOnly
void keyPressed(){
  if(key==CODED){
    if(keyCode == UP){player.move("UP");}
    if(keyCode == DOWN){player.move("DOWN");}
    if(keyCode == LEFT){player.move("LEFT");}
    if(keyCode == RIGHT){player.move("RIGHT");}
  }
  
  
  if(key=='a'){
    showNotice("MANA KITA XALKELI SAMA \n NOMONA XIKELA");
  }
  if(key =='s'){
    saveData();
    showMessage("saved");
  }
  if(key == 'd'){
    player.ix = 11;
    player.iy = 3;
  }
  if(key == 'f'){
    transitionDir = "DOWN";
    transitionFrame = 0;
    transition = true;
  }
}
