boolean popUpMenu = true;
int popUpSize = 4;
Button[] abilityButton;
boolean abilityButtonInited;
String popUpPosition = "RIGHT";

void initAbilityButton(float popUp_x, float popUp_y, float marginX, float marginY){
   abilityButton = new Button[player.ability.length];
    for( int i = 0; i < abilityButton.length; i++){
      float button_x = popUp_x + marginX;
      float button_y = popUp_y + marginY + i * (  gridsize + marginY );
      button_x = button_x / gridsize;
      button_y = button_y / gridsize;
      String commandDetail = player.ability[i];
      abilityButton[i] = new Button(button_x, button_y, gridsize, gridsize, "abilityClicked", commandDetail, nan, false);
    }
}

void resetAbilityButton(){
  abilityButtonInited = false;
}


void popUpMenu(){
  
  if(popUpMenu){
    
    float messageMarginX = 0.4 * gridsize;
    float messageMarginY = 0.4 * gridsize;
        
    int popUp_ix;
    int popUp_iy;
    float popUp_x;
    float popUp_y;
    //float abilityButtonMargin = gridsize * 0.5;
    
    float popUp_wx = gridsize + 2*messageMarginX;
    float popUp_wy = popUpSize * gridsize + 2*messageMarginY;
    
    popUp_ix = selectedObject_ix + 1;
    popUp_iy = selectedObject_iy;
    
        
    //checkin whether a button is covered or not
    for( Button[] bts : fieldbuttons){
    for( Button b : bts){
      int popUpSizeX = ceil(popUp_wx/gridsize);
      int popUpSizeY = ceil(popUp_wy/gridsize);
      boolean inX = (popUp_ix <= b.ix)&&(b.ix < popUp_ix + popUpSizeX);
      boolean inY = (popUp_iy <= b.iy)&&(b.iy < popUp_iy + popUpSizeY);
      if( inX && inY ){ 
        coveredButtons[int(b.ix)][int(b.iy)] = true;
      }
    }
    }
    
     //calculating global position
    popUp_x = popUp_ix * gridsize + 0.4 * messageMarginX;
    popUp_y = popUp_iy * gridsize - 0.5 * gridsize;
    //fill(100,200,100); stroke(0); strokeWeight(2);
    fill(0,0,0,200); noStroke();
    
    
    
    //drawing object
    rect(popUp_x, popUp_y, popUp_wx, popUp_wy, 50);
    
    //initializing button
    if(!abilityButtonInited){
      initAbilityButton(popUp_x, popUp_y, messageMarginX, messageMarginY);
      abilityButtonInited = true;
    }
  
    
    //show
    
    Object o = objects[selectedObject_ix][selectedObject_iy];
    String objectProperties = o.type;
    for(String str : o.attributes){ objectProperties = objectProperties + ":" + str; }
    
    fill(255);
    //text(objectProperties, popUp_x + (0.5)*gridsize, popUp_y + (0.5)*gridsize);
    
    for ( Button b : abilityButton ){
      b.show();
      fill(0);
      textFont(defaultFont);
      textSize(textSize);
      text(b.commandDetail, b.x + gridsize, b.y + 20);
    }
    
    
  }
  
  
}
