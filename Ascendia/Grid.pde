  int n_grid_x = 13;
int n_grid_y = 8;
float wx, wy;
float gridsize;
float margin_x, margin_y;
float margin_hard = 0.5; // how many time initial gridsize
float textSize;
float textLeading;

int[] tiles = new int[n_grid_x * n_grid_y];
int[] high  = new int[n_grid_x * n_grid_y];

void screen_ratio(){
  
  float gridsize_x = floor(width/n_grid_x); 
  float gridsize_y = floor(height/n_grid_y);
  float agridsize = min(gridsize_x, gridsize_y); //calculatin gridsize in pixel
  
  float margin_correction = (1)*agridsize;
  if ( width < height ){  margin_correction = margin_correction / n_grid_y;
  } else               {  margin_correction = margin_correction / n_grid_x;
  }
  
  gridsize = agridsize - margin_correction;
  
  
  margin_x = (width  - gridsize * n_grid_x)/2 ;  //margin x
  margin_y = (height - gridsize * n_grid_y)/2 ;  //margin y
  
  textSize = gridsize/3;
  textLeading = textSize;
  textSize(textSize);
  textLeading(textLeading);
  
}

void guide_grid(){
  
  for(int i = 0; i < n_grid_x; i++){
    for(int j = 0; j < n_grid_y; j++){
      noFill(); stroke(255,255,255,20); strokeWeight(1);
      float x = i*gridsize;
      float y = j*gridsize;
      rect(x,y,gridsize,gridsize);
    }
  }
  
 
  
}

void guide_cursor(){
  stroke(255);
  
  float translated_mouseX = mouseX - margin_x;
  float translated_mouseY = mouseY - margin_y;
  float cur_x = floor(translated_mouseX/gridsize)*gridsize + gridsize/2 ;
  float cur_y = floor(translated_mouseY/gridsize)*gridsize + gridsize/2 ;
  
  line(-margin_x , cur_y , width , cur_y );
  line(cur_x , 0 , cur_x , height);
}
