int cutscene = 0;
boolean cut_init = true;
float cutFrame = 0;
void cutscenes(){
  if(!cut_init){
    cutFrame = 0;
    cut_init = true;
  }
  if (cutscene == 0){ cuts0(); }//0.0
  if (cutscene == 1){ cuts1(); }//0.1
  if (cutscene == 2){ cuts2(); }//0.2
  
}

void cuts0(){
  float typeLength = 0.7; //0.7
  float pauseLength = 25; //25
  float closeLength = 20;
  String[] texts = new String[6];
  String[] towrite = new String[6];
  textFont(skeyFont);
  textSize(textSize);
  textAlign(LEFT);
  texts[0] = "X   PEDO BITU RQ? ..";
  texts[1] = "F   MOKO SIRAME XISA ..";
  texts[2] = "X   SIXQ . XATE FINEPE ..";
  texts[3] = "     SUTE PEKA XIPA XO BADIWQ YADQ SIPECU .";
  texts[4] = "F   SUTE . HAHA .. SIXE ..";
  texts[5] = "     XA . FA . JA .."; 
  
  float framing;
  
  //typing the texts
  framing = cutFrame;
    if(framing >= 0){ towrite[0] = texts[0].substring(0, min(ceil(framing/typeLength), texts[0].length() )); }
  framing = cutFrame - texts[0].length() - pauseLength;
    if(framing >= 0){ towrite[1] = texts[1].substring(0, min(ceil(framing/typeLength), texts[1].length() )); }
  framing = cutFrame - texts[0].length() - texts[1].length() - 2*pauseLength;
    if(framing >= 0){ towrite[2] = texts[2].substring(0, min(ceil(framing/typeLength), texts[2].length() )); }
  framing = cutFrame - texts[0].length() - texts[1].length() - texts[2].length() - 2*pauseLength;
    if(framing >= 0){ towrite[3] = texts[3].substring(0, min(ceil(framing/typeLength), texts[3].length() )); }
  framing = cutFrame - texts[0].length() - texts[1].length() - texts[2].length() - texts[3].length() - 3*pauseLength;
    if(framing >= 0){ towrite[4] = texts[4].substring(0, min(ceil(framing/typeLength), texts[4].length() )); }
  framing = cutFrame - texts[0].length() - texts[1].length() - texts[2].length() - texts[3].length() - 5*pauseLength;
    if(framing >= 0){ towrite[5] = texts[5].substring(0, min(ceil(framing/typeLength/20), texts[5].length() )); }
    
    
  float totalTextLength = 0;
  for(String t : texts){ totalTextLength += t.length(); }
  totalTextLength = (totalTextLength - texts[5].length())*typeLength + (texts[5].length())*20*typeLength ;
  
  //writing the texts
  fill(255);
  pushMatrix();
  rotate(PI/2);
  for(int i = 0; i < towrite.length; i++){
    if(towrite[i] != null){
    text(towrite[i],0,-textSize*i);
    }
  }
  popMatrix();
  
  
  //closing animation
  framing = cutFrame - totalTextLength - 5*pauseLength;
  if(framing >= 0){
    float value = map(framing,0,closeLength,PI/2,0);
    float sin = 1-sin(value);
    fill(0);
      //top
    rect(-margin_x, -margin_y, width, sin*height/2);
      //bottom
    rect(width-margin_x, height-margin_y, -width, -sin*height/2);
  }
  
  
  //calculating when to end
  float totalLength = (totalTextLength + 6*pauseLength + closeLength);
  if(cutFrame >= totalLength){
    setButtonCommand("cutstart");
    setButtonCommandDetail("1");
  }
  
  
  cutFrame++;
}



void cuts1(){
  background(254,211,133);
  float tolerance = gridsize;  
  float eyeLength = 60;
  float pauseLength = 30;
  float nothingLength = 240;
  float framing;
  float sin = 1;
  
  float totalEye = 4*eyeLength + 3*pauseLength;
  
  float offset1 = map(noise(2*sin(cutFrame/555),2*cos(cutFrame/555)),0,1,-1,1)*tolerance/1;
  float offset2 = map(noise(2*cos(cutFrame/666),2*sin(2*cutFrame/666)),0,1,-1,1)*tolerance/1;
   image(back1,-margin_x - tolerance + offset1,-margin_y - tolerance + offset2,width+2*tolerance,height+2*tolerance);
  
  //float alpha = map(cutFrame,0,totalEye,200,0);
  float alpha = map(cutFrame,0,totalEye,0,1);
  alpha = alpha*alpha;
  alpha = map(alpha,0,1,200,0);
  fill(0,alpha); noStroke();
  rect(-margin_x, -margin_y, width, height);
  
  framing = cutFrame - pauseLength;
  if((eyeLength > framing)&&(framing >= 0)){ float value = map(framing,0,eyeLength,0,PI); sin = 1 - sin(value);  }
  framing = cutFrame - pauseLength - eyeLength;
  if((eyeLength > framing)&&(framing >= 0)){ float value = map(framing,0,eyeLength,0,PI); sin = 1 - sin(value);  map(sin,0,1,0.4,1);}
  framing = cutFrame - 2*pauseLength - 2*eyeLength;
  if((eyeLength > framing)&&(framing >= 0)){ float value = map(framing,0,eyeLength,0,PI); sin = 1 - sin(value);  map(sin,0,1,0.4,1);}
  framing = cutFrame - 3*pauseLength - 3*eyeLength;
  if((eyeLength > framing)&&(framing >= 0)){ float value = map(framing,0,eyeLength,0,PI/2); sin = 1 - sin(value);  }
  
  if(cutFrame >= totalEye){
    sin = 0;
  }
  fill(0);noStroke();
  rect(-margin_x, -margin_y, width, sin*height/2);
  rect(width-margin_x, height-margin_y, -width, -sin*height/2);
  
  
  if(cutFrame >= totalEye + nothingLength){
    setButtonCommand("cutstart");
    setButtonCommandDetail("2");
  }
  
  cutFrame++;
}

void cuts2(){
  setButtonCommand("gamestart");
}
