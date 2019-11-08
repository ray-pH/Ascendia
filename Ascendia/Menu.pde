boolean menuinit = true;
Button startbutton;


void mainmenu(){
  
  if(menuinit){
    startbutton = new Button(width/2/gridsize - margin_x/gridsize,6, width*2/3,height*1/6,"cutstart","0",nan,true);
    //startbutton = new Button(400,200,200,100,"gamestart",true);
    menuinit = false;
  }
    //background(254,211,133);
    background(10);

  float logo_wy = 5*gridsize;
  float logo_wx = logo_wy*2;
  float logo_x  = width/2 - margin_x - logo_wx/2;
  float logo_y  = gridsize/5;
  
  image(logo,logo_x, logo_y, logo_wx, logo_wy);
  startbutton.show();
  
  
  
  
}
