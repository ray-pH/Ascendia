void saveData(){
  
  //abilities
  Table toSave_abilities = new Table();
  
  for(int i = 0; i < abilities.length; i++ ){
    String ab = abilities[i];
    toSave_abilities.setString(i,0,ab);
    toSave_abilities.setString(i,1,abilitiesBool.get(ab));
  }

  saveTable(toSave_abilities,"data/datas/abilities.csv");
  
}

void resetData(){
  Table toReset_abilities = loadTable("reset/data/abilities.csv");
  saveTable(toReset_abilities,"data/datas/abilities.csv");
}
