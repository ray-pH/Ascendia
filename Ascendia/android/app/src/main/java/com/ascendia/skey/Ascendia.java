package com.ascendia.skey;

import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Ascendia extends PApplet {

int menu;
String ButtonCommand;
String ButtonCommandDetail;;
public void setup(){
  
  
  orientation(LANDSCAPE);
  
  //size(800,600, P2D);
  //surface.setResizable(true);
  
  frameRate(60);
  menu = 0;
  abilities_init();
  maps_init();
  
  
  //debug
  setButtonCommand("gamestart");
}

/*  menu 0 : mainmenu
         1 : game
*/


public void draw(){
  translate(margin_x,margin_y);
  background(0);
  screen_ratio();
  if(ButtonCommand != null){
  listenButton();
  }
  if (menu == 0) { mainmenu(); }
  if (menu == 1) { game(); }
}


//debugOnly
public void keyPressed(){
  if(key=='a'){
    showMessage("a");
  }
}
class Button{
  
  float ix, iy;
  float x,y,wx,wy;
  PImage img;
  boolean hover, held, released;
  String command, commandDetail;
  boolean covered = false;
  
  int colorNormal  = color(200);
  int colorHovered = color(255);
  
  Button(float ix, float iy, float wx, float wy, String command, String commandDetail, boolean center){
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
    //this.img = img;
    
    if(center){
      this.x = this.x - this.wx/2;
      this.y = this.y - this.wy/2;
    }
  }
  
  public void show(){
    if(!covered){
      this.checkHover();
      this.logic();
      fill( (hover) ? colorHovered : colorNormal ); 
      rect(x,y,wx,wy);
    }
  }
  
  
  public void checkHover(){
    
    //translating mouse position
    float translated_mouseX = mouseX - margin_x;
    float translated_mouseY = mouseY - margin_y;
    
    //checking if mouse is hovering
    if ( ( x <= translated_mouseX ) && ( translated_mouseX <= x+wx ) && 
         ( y <= translated_mouseY ) && ( translated_mouseY <= y+wy ) ){
           this.hover = true;
           
    }else{ this.hover = false; }    
  }
  
  public void logic(){
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
  
 
public void setButtonCommand(String command){
  //function to set global commnad
  ButtonCommand = command;
}

public void setButtonCommandDetail(String command){
  //function to set global commnad
  ButtonCommandDetail = command;
}

public void resetButtonCommand(){
  //function to reset
  ButtonCommand = "";
}

public void listenButton(){
  
  if(ButtonCommand.equals("gamestart")){
    Table playerData = loadTable("data/player.csv");
    int level       = PApplet.parseInt(playerData.getString(0,1));
    String position = playerData.getString(1,1);
    startLevel(level,position);
    resetButtonCommand();
  }
  
  if(ButtonCommand.equals("objectClicked")){
    String[] datas = split(ButtonCommandDetail, ','); //splitting ButtonCommandDetail using coma
    selectedObject_ix = PApplet.parseInt(datas[0]);
    selectedObject_iy = PApplet.parseInt(datas[1]);
    Object o = objects[selectedObject_ix][selectedObject_iy];
    
    resetCoverderButtons();    
    
    if( o != null ){
      
      
      
    }
    //if player click the ground
    if( o == null ){      
      float dx = selectedObject_ix - player.ix;
      float dy = selectedObject_iy - player.iy;
           if(( dx == 0 )&&( dy >= 1)){ player.move("DOWN" ); }
      else if(( dx == 0 )&&( dy <=-1)){ player.move( "UP"  ); }
      else if(( dx >= 1 )&&( dy == 0)){ player.move("RIGHT"); }
      else if(( dx <=-1 )&&( dy == 0)){ player.move("LEFT" ); }
      
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
int level = 0;
boolean map_loaded = false;

Player player = new Player(0,0,0);
int player_ix_init = 0;
int player_iy_init = 0;

public void startLevel(int lv, String position){
  level = lv;
  
  //making entrance position equal map's
  if(position.equals("TOP")){
    player_ix_init = maps[level].top_ix;
    player_iy_init = maps[level].top_iy;
  }
  else if(position.equals("BOTTOM")){
    player_ix_init = maps[level].bottom_ix;
    player_iy_init = maps[level].bottom_iy;
  }
  else if(position.equals("LEFT")){
    player_ix_init = maps[level].left_ix;
    player_iy_init = maps[level].left_iy;
  }
  else if(position.equals("RIGHT")){
    player_ix_init = maps[level].right_ix;
    player_iy_init = maps[level].right_iy;
  }
  
  //load the map
  map_load();
  map_loaded = true;
  
  //set mode to gameplay
  menu = 1;
}

public void game(){
  
  guide_grid();
  
  // if the map is not loaded yt, load the map
  if(!map_loaded){
    map_load();
    map_loaded = true;
  }
  
  updateFieldButton();
  
  //show all button
  for( Button[] bts : fieldbuttons){
    for( Button b : bts){
      b.show();
    }
  }
  
  player.show();
  
  //show all objects
  for( Object[] obs : objects){
    for( Object o : obs){
      if ( o != null ){
        o.show();
      }
    }
  }
  
  message();
  
  
  
}

public void map_load(){
  for(int i = 0; i < n_grid_x; i++){
    for(int j = 0; j < n_grid_y; j++){
      String type = maps[level].map.getString(j,i);
      if (!type.equals("0")){
        objects[i][j] = new Object(i, j, type);
      } else {
        objects[i][j] = null;
      }
      
      //createutton
      String command = "objectClicked";
      String commandDetail = str(i) + "," + str(j);
      fieldbuttons[i][j] = new Button(i, j, gridsize, gridsize, command, commandDetail, false);
    }
  }
  
  //objects[player_ix_init][player_iy_init] = new Object(player_ix_init, player_iy_init, "Player");
  player.ix = player_ix_init;
  player.iy = player_iy_init;
  
}
  int n_grid_x = 14;
int n_grid_y = 10;
float wx, wy;
float gridsize;
float margin_x, margin_y;
float margin_hard = 0.5f; // how many time initial gridsize

int[] tiles = new int[n_grid_x * n_grid_y];
int[] high  = new int[n_grid_x * n_grid_y];

public void screen_ratio(){
  
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
}

public void guide_grid(){
  
  for(int i = 0; i < n_grid_x; i++){
    for(int j = 0; j < n_grid_y; j++){
      noFill(); stroke(255); strokeWeight(1);
      float x = i*gridsize;
      float y = j*gridsize;
      rect(x,y,gridsize,gridsize);
    }
  }
  
}

Map[] maps = new Map[1];

public void maps_init(){
  maps[0] = new Map("map0.csv", 0, 0); 
}

class Map {
  Table map;
  int mx, my;
  int top_ix, top_iy;
  int bottom_ix, bottom_iy;
  int left_ix, left_iy;
  int right_ix, right_iy;
  
  Map(String smap, int mx, int my){
    smap = "maps/" + smap; 
    this.map = loadTable(smap);
    this.mx = mx;
    this.my = my;
    
     //getting entrance coordinate
    this.top_ix    = PApplet.parseInt(map.getString( n_grid_y + 0, 1));
    this.top_iy    = PApplet.parseInt(map.getString( n_grid_y + 0, 2));
    this.bottom_ix = PApplet.parseInt(map.getString( n_grid_y + 1, 1));
    this.bottom_iy = PApplet.parseInt(map.getString( n_grid_y + 1, 2));
    this.left_ix   = PApplet.parseInt(map.getString( n_grid_y + 2, 1));
    this.left_iy   = PApplet.parseInt(map.getString( n_grid_y + 2, 2));
    this.right_ix  = PApplet.parseInt(map.getString( n_grid_y + 3, 1));
    this.right_iy  = PApplet.parseInt(map.getString( n_grid_y + 3, 2));
    
  }
  
  
  
}
boolean menuinit = true;
Button startbutton;


public void mainmenu(){
  
  if(menuinit){
    startbutton = new Button(width/2/gridsize,height/2/gridsize,width*2/3,height*1/6,"gamestart","",true);
    //startbutton = new Button(400,200,200,100,"gamestart",true);
    menuinit = false;
  }
  
  startbutton.show();
  
  
  
  
}
String message;
String messageType;
boolean showMessage = false;
int messageFrame = 0;
float messageAnimationLength = 60;
float goDownTime = 1.0f/6;

float message_iwy = 2 ;

public void showMessage(String Msg){
  showMessage = true;
  messageFrame = 0;
  messageType  = "Message";
}

public void showNotice(String Msg){
  showMessage = true;
  messageFrame = 0;
  messageType  = "Notice";
}

public void message(){
  if(showMessage){
    float pos_y = -margin_y/2;
    float message_wy = 0;
    float message_wx = 0;
    float alpha = 255;
    if(messageFrame > messageAnimationLength*(1-goDownTime) ){
      alpha = map(messageFrame, messageAnimationLength*(1-goDownTime), messageAnimationLength,255,0);
    }
    
    if(messageType.equals("Message")){
      message_wy = message_iwy * gridsize;
      message_wx = (n_grid_x - 2) * gridsize;
    }else if(messageType.equals("Notice")){
      message_wy = message_iwy * gridsize;
      message_wx = (n_grid_x - 2) * gridsize;
    }
    
    noStroke();
    fill(100,100,200,alpha);
    rect(gridsize, pos_y, message_wx, message_wy);
    messageFrame += 1;
    if(messageFrame >= messageAnimationLength){
      showMessage = false;
    }
    
    
  }
}
Button[][] fieldbuttons= new Button[n_grid_x][n_grid_y];
boolean[][] coveredButtons = new boolean[n_grid_x][n_grid_y];

public void resetCoverderButtons(){
  for(int i = 0; i < n_grid_x; i++){
    for(int j = 0; j < n_grid_y; j++){
      coveredButtons[i][j] = false;
    }
  }
}

public void updateFieldButton(){
  if(fieldbuttons[0][0].wx != gridsize){
    for(int i = 0; i < n_grid_x; i++){
    for(int j = 0; j < n_grid_y; j++){
            String command = "objectClicked";
      String commandDetail = str(i) + "," + str(j);
      fieldbuttons[i][j] = new Button(i, j, gridsize, gridsize, command, commandDetail, false);
    }
  }
  }
  for( Button[] bts : fieldbuttons){
    for( Button b : bts){
      if(coveredButtons[PApplet.parseInt(b.ix)][PApplet.parseInt(b.iy)] == true){
        b.covered = true;
      }else{
        b.covered = false;
      }
    }
  }
}
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
  
  Object(int ix, int iy, String data){
    this.ix = ix;
    this.iy = iy;
    this.x  = ix * gridsize;
    this.y  = iy * gridsize;
    
    String[] datas = split(data, ':');
    
    this.type = datas[0];
    this.attributes = new String[datas.length-1];
    arrayCopy(datas, 1, this.attributes, 0, datas.length-1); 
  }
  
  public void show(){
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
    
    //show the text
    if(!coveredButtons[this.ix][this.iy]){
    fill(0);
    text(type,x,y+gridsize/2);
    }
    
    //if this object is selectrf
    if((this.ix == selectedObject_ix)&&(this.iy == selectedObject_iy)){
      fill(200,50,50); strokeWeight(1); stroke(255);
      rect(this.x,this.y,gridsize,gridsize);
      popUpMenu();
    }
    
    
    
  }
  
  public void move(String direction){
    
    String d = direction;
    
    this.old_ix = this.ix;
    this.old_iy = this.iy;
    
    if(( d == "UP"   )&&( objects[this.ix][this.iy - 1] == null ))  { this.iy = this.iy - 1; }
    if(( d == "DOWN" )&&( objects[this.ix][this.iy + 1] == null ))  { this.iy = this.iy + 1; }
    if(( d == "LEFT" )&&( objects[this.ix - 1][this.iy] == null ))  { this.ix = this.ix - 1; }
    if(( d == "RIGHT")&&( objects[this.ix + 1][this.iy] == null ))  { this.ix = this.ix + 1; }
    this.animate(); 
    
    updateObjects();
    resetAbilityButton();
  }
  
  public void animate(){
    //calculating step per frame of animation
    this.animation_dx = PApplet.parseFloat( this.ix - old_ix ) / this.animationLength;
    this.animation_dy = PApplet.parseFloat( this.iy - old_iy ) / this.animationLength;
    //reseting animationFrame
    this.animationFrame = 0;
    this.animated = true ;
  }
  
  
}


public void updateObjects(){
  
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
Table abilitiesTable;
String[] abilities;
StringDict abilitiesBool = new StringDict();
Table passiveAbilitiesTable;
String[] passiveAbilities;
StringDict passiveAbilitiesBool = new StringDict();

public void abilities_init(){
  abilitiesTable = loadTable("data/abilities.csv");
  passiveAbilitiesTable = loadTable("data/passiveAbilities.csv");
  int tableLength = abilitiesTable.getRowCount();
  abilities = new String[tableLength];
  for(int i = 0; i < tableLength; i++){
    String ability = abilitiesTable.getString(i,0);
    String abilityBool = abilitiesTable.getString(i,1);
    abilities[i] = ability;
    abilitiesBool.set(ability, abilityBool);
  }
  
  int passiveTableLength = passiveAbilitiesTable.getRowCount();
  passiveAbilities = new String[passiveTableLength];
  for(int i = 0; i < passiveTableLength; i++){
    String passiveAbility = passiveAbilitiesTable.getString(i,0);
    String passiveAbilityBool = passiveAbilitiesTable.getString(i,1);
    passiveAbilities[i] = passiveAbility;
    passiveAbilitiesBool.set(passiveAbility, passiveAbilityBool);
  } 
}

public void getNewAbility(String newAbility){
  abilitiesBool.set(newAbility, "true");
  player.update_ability();
  resetAbilityButton();
}
public void getNewPassiveAbility(String newAbility){
  passiveAbilitiesBool.set(newAbility, "true");
  player.update_ability();
  resetAbilityButton();
}


public void doAbility(String theAbility){
  Object o = objects[selectedObject_ix][selectedObject_iy];
  
  if(theAbility.equals("inspect")){
    for(String properties : o.attributes){
      if(abilitiesBool.get(properties) != null ){
        if( abilitiesBool.get(properties).equals("false") ){
          getNewAbility(properties);
          showMessage(properties + " learned");
        }
      }
    }
  }
  
  
  if(theAbility.equals("push")){
        
    boolean pushable = false;
    for(String ppt : o.attributes){
      pushable = (pushable) || (ppt.equals("push")) ; 
    }
    if(pushable){
      float radius = 0;
    if(passiveAbilitiesBool.get("radius1").equals("true")){ radius = 1; }
    if(passiveAbilitiesBool.get("radius2").equals("true")){ radius = 2; }
    if(passiveAbilitiesBool.get("radius3").equals("true")){ radius = 3; }
    float dx = selectedObject_ix - player.ix;
    float dy = selectedObject_iy - player.iy;
    float dist = sqrt( pow(dx,2) + pow(dy,2)  );
    boolean reach = (dist <= radius);
      Player p = player;     
      if(reach){
       String dir = "";
           if(( dx == 0 )&&( dy >= 1)){ dir = "DOWN" ; selectedObject_iy++; }
      else if(( dx == 0 )&&( dy <=-1)){ dir = "UP"   ; selectedObject_iy--; }
      else if(( dx >= 1 )&&( dy == 0)){ dir = "RIGHT"; selectedObject_ix++; }
      else if(( dx <=-1 )&&( dy == 0)){ dir = "LEFT" ; selectedObject_ix--; }
      o.move(dir);
      p.move(dir);
      }
      else{
        showNotice("too far");
      }
      
      
      
    }else{
      showNotice("unPushable");
    }
    
  }
  
}
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
  int animationFrame = 0;
  float animation_dx, animation_dy;
  
  String[] ability;
  String[] passiveAbility;
  
  Player(int ix, int iy, int dir){
    this.ix = ix;
    this.iy = iy;
    this.x = ix * gridsize;
    this.y = iy * gridsize;
    this.direction = dir;
    this.radius = 1;
  }
  
  public void show(){
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
     float n = 0;
     for( String a : this.ability){
       text(a,20,20+n*20);
       n++;
     
     }
    
    fill(50,200,50); strokeWeight(1); stroke(255);
    ellipseMode(CORNER);
    ellipse(x,y,gridsize,gridsize);
  }
  
  public void move(String direction){
    
    String d = direction;
    
    this.old_ix = this.ix;
    this.old_iy = this.iy;
    
    if(( d.equals("UP")   )&&( objects[this.ix][this.iy - 1] == null ))  { this.iy = this.iy - 1; }
    if(( d.equals("DOWN") )&&( objects[this.ix][this.iy + 1] == null ))  { this.iy = this.iy + 1; }
    if(( d.equals("LEFT") )&&( objects[this.ix - 1][this.iy] == null ))  { this.ix = this.ix - 1; }
    if(( d.equals("RIGHT"))&&( objects[this.ix + 1][this.iy] == null ))  { this.ix = this.ix + 1; }
    this.animate(); 
  }
  
  public void animate(){
    //calculating step per frame of animation
    this.animation_dx = PApplet.parseFloat( this.ix - old_ix ) / this.animationLength;
    this.animation_dy = PApplet.parseFloat( this.iy - old_iy ) / this.animationLength;
    //reseting animationFrame
    this.animationFrame = 0;
    this.animated = true ;
  }
  
  public void update_ability(){
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
  
  
}
boolean popUpMenu = true;
int popUpSize = 4;
Button[] abilityButton;
boolean abilityButtonInited;


public void initAbilityButton(float popUp_x, float abilityButtonMargin){
   abilityButton = new Button[player.ability.length];
    for( int i = 0; i < abilityButton.length; i++){
      float button_x = popUp_x + abilityButtonMargin;
      float button_y = i * (  gridsize + abilityButtonMargin) + abilityButtonMargin;
      button_x = button_x / gridsize;
      button_y = button_y / gridsize;
      String commandDetail = player.ability[i];
      abilityButton[i] = new Button(button_x, button_y, gridsize, gridsize, "abilityClicked", commandDetail, false);
    }
}

public void resetAbilityButton(){
  abilityButtonInited = false;
}


public void popUpMenu(){
  
  if(popUpMenu){
        
    String popUpPosition = "MIDDLE";
    int popUp_ix = 0;
    int popUp_iy = 0;
    float popUp_x;
    float popUp_y;
    float abilityButtonMargin = gridsize * 0.5f;
    
    //checking position of clicke object
    //if object in the left, pop up in the right, vice versa
    if(selectedObject_ix >= floor(n_grid_x/2)){ popUpPosition = "LEFT" ; }
    else                                      { popUpPosition = "RIGHT"; }
    
    if      ( popUpPosition == "RIGHT" ){ popUp_ix = n_grid_x - popUpSize; }
    else if ( popUpPosition == "LEFT"  ){ popUp_ix = 0; }
        
    //checkin whether a button is covered or not
    for( Button[] bts : fieldbuttons){
    for( Button b : bts){
      boolean inX = (popUp_ix <= b.ix)&&(b.ix < popUp_ix + popUpSize);
      if( inX ){ 
        coveredButtons[PApplet.parseInt(b.ix)][PApplet.parseInt(b.iy)] = true;
      }
    }
    }
    
     //calculating global position
    popUp_x = popUp_ix * gridsize;
    popUp_y = popUp_iy * gridsize;
    fill(100,200,100); stroke(0); strokeWeight(2);
    
    float popUp_wx = popUpSize * gridsize;
    float popUp_wy = n_grid_y * gridsize;
    
    //drawing object
    rect(popUp_x, popUp_y, popUp_wx, popUp_wy);
    
    //initializing button
    if(!abilityButtonInited){
      initAbilityButton(popUp_x, abilityButtonMargin);
      abilityButtonInited = true;
    }
  
    
    //show
    
    Object o = objects[selectedObject_ix][selectedObject_iy];
    String objectProperties = o.type;
    for(String str : o.attributes){ objectProperties = objectProperties + ":" + str; }
    
    fill(255);
    text(objectProperties, popUp_x + (0.5f)*gridsize, popUp_y + (0.5f)*gridsize);
    
    for ( Button b : abilityButton ){
      b.show();
      fill(0);
      text(b.commandDetail, b.x, b.y + 20);
    }
    
    
  }
  
  
}
  public void settings() {  size(displayWidth,displayHeight,P2D); }
}
