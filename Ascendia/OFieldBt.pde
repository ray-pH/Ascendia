Button[][] fieldbuttons= new Button[n_grid_x][n_grid_y];
boolean[][] coveredButtons = new boolean[n_grid_x][n_grid_y];

void resetCoverderButtons(){
  for(int i = 0; i < n_grid_x; i++){
    for(int j = 0; j < n_grid_y; j++){
      coveredButtons[i][j] = false;
    }
  }
}

void updateFieldButton(){
  if(fieldbuttons[0][0].wx != gridsize){
    for(int i = 0; i < n_grid_x; i++){
    for(int j = 0; j < n_grid_y; j++){
            String command = "objectClicked";
      String commandDetail = str(i) + "," + str(j);
      fieldbuttons[i][j] = new Button(i, j, gridsize, gridsize, command, commandDetail, desertback, false);
    }
  }
  }
  for( Button[] bts : fieldbuttons){
    for( Button b : bts){
      if(coveredButtons[int(b.ix)][int(b.iy)] == true){
        b.covered = true;
      }else{
        b.covered = false;
      }
    }
  }
}
