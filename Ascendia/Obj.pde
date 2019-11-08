Object[][] objects= new Object[n_grid_x][n_grid_y];
int selectedObject_ix = -2;
int selectedObject_iy = -2;

class Object{
  int ix, iy;
  float x, y;
  String type;
  String[] attributes;
  
  int old_ix = 0;
  int old_iy = 0;
  
  int animationLength = 6;
  boolean animated = false;
  int animationFrame = 0;
  float animation_dx, animation_dy;
  
  PImage img;
  
  Object(int ix, int iy, String data){
    this.ix = ix;
    this.iy = iy;
    this.x  = ix * gridsize;
    this.y  = iy * gridsize;
    
    String[] datas = split(data, ':');
    
    this.type = datas[0];
    this.attributes = new String[datas.length-1];
    arrayCopy(datas, 1, this.attributes, 0, datas.length-1); 
    
    if(this.type.equals("wall")){
      this.checkWall();
      this.img.resize(int(gridsize), 2*int(gridsize));
    }else{
      this.getImg();
    }
  }
  
  void show(){
    this.x  = ix * gridsize;
    this.y  = iy * gridsize;
    
    if(animated){
      this.x = (this.old_ix * gridsize ) + (this.animation_dx * this.animationFrame * gridsize);
      this.y = (this.old_iy * gridsize ) + (this.animation_dy * this.animationFrame * gridsize);
      this.animationFrame += 1;
      
      if(this.animationFrame >= this.animationLength){
        this.animated = false;
      }
      
      
    }
    
    //if this object is selectrf
    if((this.ix == selectedObject_ix)&&(this.iy == selectedObject_iy)){
      fill(200,50,50,50); strokeWeight(1); stroke(255);
      rect(this.x,this.y,gridsize,gridsize);
      //popUpMenu();
    }
    
    //if this object has img and is not covered
    //if((this.img != null)&&(!coveredButtons[this.ix][this.iy])){
    if((this.img != null)){
      //for normal object
      if(!this.type.equals("wall")){
        image(this.img,this.x,this.y - gridsize/2 ,gridsize,gridsize);
        //image(this.img,this.x,this.y - gridsize/2);
      }
      //wall exception
      else{
        //if not in bottom
        if(this.iy != n_grid_y-1){
          image(this.img,this.x,this.y - gridsize, gridsize, 2*gridsize);
        //if in bottom
        }else{
          //if((this.ix == 0)||(this.ix == n_grid_x - 1)){
          if(objects[this.ix][this.iy-1] != null){
            if(objects[this.ix][this.iy-1].type.equals("wall")){
            image(this.img,this.x,this.y - gridsize, gridsize, 2*gridsize);
            image(wall,this.x,this.y, gridsize, 2*gridsize);
            }else{
              image(wallBottom,this.x,this.y, gridsize, 2*gridsize);
            }
          }else{
          image(wallBottom,this.x,this.y, gridsize, 2*gridsize);
          }
        }
      }
    }
    
    if(this.type.equals("rightDoor")){
      fill(255,70); noStroke();
      float offset = 0.16*gridsize;
      rect((this.ix-1)*gridsize, this.iy*gridsize - offset, 2*gridsize, gridsize + offset);
    }
    else if(this.type.equals("leftDoor")){
      fill(255,70); noStroke();
      float offset = 0.16*gridsize;
      rect((this.ix)*gridsize, this.iy*gridsize - offset, 2*gridsize, gridsize + offset);
    }
    //show the text
    else if(this.img == null)
    {
    if(!coveredButtons[this.ix][this.iy]){
    fill(0);
    textSize(textSize);
    text(type,x+gridsize/2,y+gridsize/2);
    }
    }
    
    
    
    
    
  }
  
  boolean selected(){
    if((this.ix == selectedObject_ix)&&(this.iy == selectedObject_iy)){
      return true;
    }else{
      return false;
    }
  }
  
  void move(String direction){
    
    String d = direction;
    
    this.old_ix = this.ix;
    this.old_iy = this.iy;
    
    if(( d.equals("UP")   )&&( objects[this.ix][this.iy - 1] == null ))  { this.iy = this.iy - 1; selectedObject_iy--;}
    if(( d.equals("DOWN") )&&( objects[this.ix][this.iy + 1] == null ))  { this.iy = this.iy + 1; selectedObject_iy++;}
    if(( d.equals("LEFT") )&&( objects[this.ix - 1][this.iy] == null ))  { this.ix = this.ix - 1; selectedObject_ix--;}
    if(( d.equals("RIGHT"))&&( objects[this.ix + 1][this.iy] == null ))  { this.ix = this.ix + 1; selectedObject_ix++;}
    this.animate(); 
    
    updateObjects();
    resetAbilityButton();
  }
  
  void animate(){
    //calculating step per frame of animation
    this.animation_dx = float( this.ix - old_ix ) / this.animationLength;
    this.animation_dy = float( this.iy - old_iy ) / this.animationLength;
    //reseting animationFrame
    this.animationFrame = 0;
    this.animated = true ;
  }
  
  void checkWall(){
      this.img = wall;
    //if on the left
    if((this.ix == 0) && (!(this.iy==0))){
     this.img = wallLeft;
    }
    //if on the right
    else if((this.ix == n_grid_x-1) && (!(this.iy==0))){
      this.img = wallRight;
    }
  }
  
  void getImg(){
    if(this.type.equals("rock")){ this.img = rock; }
  }
  
}


void updateObjects(){
  
  //updating object index array
  
  Object[][] temp_objects= new Object[n_grid_x][n_grid_y];
  for( Object[] obs : objects){
    for(Object o : obs){
      if(o != null){
        int ix = o.ix;
        int iy = o.iy;
        temp_objects[ix][iy] = o;
      }
    }
  }
  
  arrayCopy(temp_objects,objects);
  
  
  
}
