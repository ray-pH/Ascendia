void setButtonCommand(String command){
  //function to set global commnad
  ButtonCommand = command;
}

void setButtonCommandDetail(String command){
  //function to set global commnad
  ButtonCommandDetail = command;
}

void resetButtonCommand(){
  //function to reset
  ButtonCommand = "";
}

void listenButton(){
  
  if(ButtonCommand.equals("cutstart")){
    menu = 2;
    cut_init = false;
    cutscene = int(ButtonCommandDetail);
    resetButtonCommand();
  }
  
  if(ButtonCommand.equals("gamestart")){
    Table playerData = loadTable("datas/player.csv");
    int level       = int(playerData.getString(0,1));
    String position = playerData.getString(1,1);
    startLevel(level,position);
    resetButtonCommand();
  }
  
  if(ButtonCommand.equals("objectClicked")){
    String[] datas = split(ButtonCommandDetail, ','); //splitting ButtonCommandDetail using coma
    selectedObject_ix = int(datas[0]);
    selectedObject_iy = int(datas[1]);
    Object o = objects[selectedObject_ix][selectedObject_iy];
    
    resetCoverderButtons();    
    
    if( o != null ){
      
      
      
    }
    //if player click the ground
    if( o == null ){      
      float dx = selectedObject_ix - player.ix;
      float dy = selectedObject_iy - player.iy;
           if(( -dy <= dx )&&( dx <  dy )){ player.move("DOWN" ); }
      else if((  dy < dx )&&( dx <= -dy )){ player.move( "UP"  ); }
      else if(( -dx < dy )&&( dy <=  dx )){ player.move("RIGHT"); }
      else if((  dx <= dy )&&( dy < -dx )){ player.move("LEFT" ); }
      
    }
    
    resetAbilityButton();
    resetButtonCommand();
  }
  
  if(ButtonCommand.equals("abilityClicked")){
    doAbility(ButtonCommandDetail);    
    resetCoverderButtons();
    resetButtonCommand();
  }
  
  
}
