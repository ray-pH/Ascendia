float playerRadius = 1;


class Player{
  int ix, iy;
  float x,y;
  int direction;
  
  int radius;
  
  int old_ix = 0;
  int old_iy = 0;
  
  int animationLength = 6;
  boolean animated = false;
  boolean justSpawned = true;
  int animationFrame = 0;
  float animation_dx, animation_dy;
  
  String[] ability;
  String[] passiveAbility;
  
  Player(int ix, int iy, int dir){
    this.ix = ix;
    this.iy = iy;
    this.direction = dir;
    this.radius = 1;
    this.justSpawned = true;
  }
  
  void show(){
    this.x = this.ix * gridsize;
    this.y = this.iy * gridsize;
    
    if(animated){
      this.x = (this.old_ix * gridsize ) + (this.animation_dx * this.animationFrame * gridsize);
      this.y = (this.old_iy * gridsize ) + (this.animation_dy * this.animationFrame * gridsize);
      this.animationFrame += 1;
      
      if(this.animationFrame >= this.animationLength){
        this.animated = false;
      }
    }
    
    
    
    this.update_ability();
    //debug showabilities
    fill(255,100);
     float n = 0;
     for( String a : this.ability){
       text(a,20,20+n*20);
       n++;
     
     }
    
    fill(50,200,50); strokeWeight(1); stroke(255);
    //ellipseMode(CORNER);
    //ellipse(x,y,gridsize,gridsize);
    image(chara, this.x, this.y - gridsize/2, gridsize, gridsize);
    
    //after animation stopped, check for the door
    if((!this.animated)&&(!this.justSpawned)){
      this.checkDoor();
    }
  }
  
  void move(String direction){
    
    String d = direction;
    
    this.old_ix = this.ix;
    this.old_iy = this.iy;
    
    boolean moved = false;
    if(( d.equals("UP")   )&&( objects[this.ix][this.iy - 1] == null ))  { this.iy = this.iy - 1; moved = true; }
    if(( d.equals("DOWN") )&&( objects[this.ix][this.iy + 1] == null ))  { this.iy = this.iy + 1; moved = true; }
    if(( d.equals("LEFT") )&&( objects[this.ix - 1][this.iy] == null ))  { this.ix = this.ix - 1; moved = true; }
    if(( d.equals("RIGHT"))&&( objects[this.ix + 1][this.iy] == null ))  { this.ix = this.ix + 1; moved = true; }
    
    if(moved){
     this.justSpawned = false; 
     transitionFrame = 0;
     moved = false;
    }
    
    this.animate();
    
  }
  
  void animate(){
    //calculating step per frame of animation
    this.animation_dx = float( this.ix - old_ix ) / this.animationLength;
    this.animation_dy = float( this.iy - old_iy ) / this.animationLength;
    //reseting animationFrame
    this.animationFrame = 0;
    this.animated = true ;
  }
  
  void update_ability(){
    this.ability = new String[0];
     for(int i = 0; i < abilities.length; i++ ){
       String ab = abilities[i];
       String able = abilitiesBool.get(ab);
       if(able.equals("true")){
         this.ability = append(this.ability, ab);
       }
     }
     this.passiveAbility = new String[0];
     for(int i = 0; i < passiveAbilities.length; i++ ){
       String ab = passiveAbilities[i];
       String able = passiveAbilitiesBool.get(ab);
       if(able.equals("true")){
         this.passiveAbility = append(this.passiveAbility, ab);
       }
     }
  }
  
  void checkDoor(){
    if(objects[this.ix + 1][this.iy] != null){
      if(objects[this.ix + 1][this.iy].type.equals("rightDoor")){ nextLevel("RIGHT");}
    }
    else if(objects[this.ix - 1][this.iy] != null){
      if(objects[this.ix - 1][this.iy].type.equals("leftDoor")){ nextLevel("LEFT"); }
    }
  }
}
