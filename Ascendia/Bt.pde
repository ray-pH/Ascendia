class Button{
  
  float ix, iy;
  float x,y,wx,wy;
  PImage img;
  boolean hover, held, released;
  String command, commandDetail;
  boolean covered = false;
  boolean center = false;
  
  color colorNormal  = color(255,255,255,0);
  color colorHovered = color(255,255,255,100);
  
  Button(float ix, float iy, float wx, float wy, String command, String commandDetail, PImage img, boolean center){
    //center mode TRUE if x,y as center
    this.ix = ix;
    this.iy = iy;
    this.x = this.ix * gridsize;
    this.y = this.iy * gridsize;
    this.wx = wx;
    this.wy = wy;
    this.command = command;
    this.commandDetail = commandDetail;
    held = false;
    released = false;
    this.img = img;
    this.center = center; 
    
    if(this.center){
      this.x = this.x - this.wx/2;
      this.y = this.y - this.wy/2;
    }
  }
  
  void show(){
    this.x = this.ix * gridsize;
    this.y = this.iy * gridsize;
    if(this.center){
      this.x = this.x - this.wx/2;
      this.y = this.y - this.wy/2;
    }
    if(!covered){
      this.checkHover();
      this.logic();
      noStroke();
      fill( (this.hover) ? colorHovered : colorNormal ); 
      image(this.img, this.x, this.y , this.wx , this.wy);
      rect(this.x,this.y,this.wx,this.wy);
    }else{
    image(this.img, this.x, this.y , this.wx , this.wy);
    }
  }
  
  
  void checkHover(){
    
    //translating mouse position
    float translated_mouseX = mouseX - margin_x;
    float translated_mouseY = mouseY - margin_y;
    
    //checking if mouse is hovering
    if ( ( x <= translated_mouseX ) && ( translated_mouseX <= x+wx ) && 
         ( y <= translated_mouseY ) && ( translated_mouseY <= y+wy ) ){
           this.hover = true;
           
    }else{ this.hover = false; }    
  }
  
  void logic(){
    //if the mouse is held, and then move out, held -> fase
    if( this.held ) { if( !this.hover){ this.held = false;  } }
    
    //if the mouse is pressed while hovering, held -> true
    if( this.hover && (mousePressed==true)){ this.held = true; }
    
    //if the mouse is released after the mouse is held, recieve as click and run command
    if( this.held && !mousePressed){ 
      setButtonCommand(this.command);
      setButtonCommandDetail(this.commandDetail);
      this.held = false; 
    }
  }
  
}
  
 
