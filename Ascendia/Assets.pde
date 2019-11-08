PImage chara;
PImage nan;
PImage desertback;

PImage wall, wallBottom, wallLeft, wallRight;
PImage rock;

PImage back1;
PImage logo;

void asset_init(){
    nan = loadImage("assets/nan.png");
    desertback = loadImage("assets/desertback.png");
    chara = loadImage("assets/char.png");
    
    wall       = loadImage("assets/wall.png");
    wallLeft   = loadImage("assets/wallLeft.png");
    wallRight  = loadImage("assets/wallRight.png");
    wallBottom = loadImage("assets/wallBottom.png");
    
    rock = loadImage("assets/rock.png");
       
       
   back1 = loadImage("assets/back1.png");
   logo = loadImage("assets/asc.png");
}

PFont defaultFont;
PFont skeyFont;
void load_font(){
  defaultFont = createFont("assets/default.ttf",72,false);
  skeyFont = createFont("assets/skey.ttf",72,false);
}
