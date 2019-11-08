Table abilitiesTable;
String[] abilities;
StringDict abilitiesBool = new StringDict();
Table passiveAbilitiesTable;
String[] passiveAbilities;
StringDict passiveAbilitiesBool = new StringDict();

void abilities_init(){
  abilitiesTable = loadTable("datas/abilities.csv");
  passiveAbilitiesTable = loadTable("datas/passiveAbilities.csv");
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

void getNewAbility(String newAbility){
  abilitiesBool.set(newAbility, "true");
  player.update_ability();
  resetAbilityButton();
}
void getNewPassiveAbility(String newAbility){
  passiveAbilitiesBool.set(newAbility, "true");
  player.update_ability();
  resetAbilityButton();
}


void doAbility(String theAbility){
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
           if(( dx == 0 )&&( dy >= 1)){ dir = "DOWN" ; }
      else if(( dx == 0 )&&( dy <=-1)){ dir = "UP"   ; }
      else if(( dx >= 1 )&&( dy == 0)){ dir = "RIGHT"; }
      else if(( dx <=-1 )&&( dy == 0)){ dir = "LEFT" ; }
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
