String message;
String messageType;
boolean showMessage = false;
int messageFrame = 0;
float messageAnimationLength = 60;
float goDownTime = 1.0/6;

float message_iwy = 2 ;

void showMessage(String Msg){
  showMessage = true;
  messageFrame = 0;
  messageType  = "Message";
  message = Msg;
}

void showNotice(String Msg){
  showMessage = true;
  messageFrame = 0;
  messageType  = "Notice";
  message = Msg;
}

void message(){
  if(showMessage){
    textFont(defaultFont,textSize);
    
    float pos_y = -margin_y/2;
    float pos_x = gridsize;
    float message_wy = 0;
    float message_wx = 0;
    float alpha = 200;
    
    float messageMarginX = 0.4 * gridsize;
    float messageMarginY = 0.2 * gridsize;
    float messageWidth = textWidth(message);
    
    if(messageFrame > messageAnimationLength*(1-goDownTime) ){
      alpha = map(messageFrame, messageAnimationLength*(1-goDownTime), messageAnimationLength,200,0);
    }
    
    if(messageType.equals("Message")){
      message_wy = message_iwy * gridsize;
      message_wx = (n_grid_x - 2) * gridsize;
    }else if(messageType.equals("Notice")){
      pos_y = player.y - 0.8*gridsize;
      pos_x = player.x + 0.8* gridsize;
      
      
      float nLine = 1;
      for(int i = 0; i < message.length(); i++){
        
        if(message.charAt(i) == '\n'){
            nLine += 1;
        }
      }
      
      message_wy = 2*messageMarginY + nLine*textSize + (nLine-1)*textLeading/2;
      message_wx = 2*messageMarginX + messageWidth;
    }
    
    
    
    noStroke();
    fill(0,0,0,alpha);
    rect(pos_x, pos_y, message_wx, message_wy, 70);
    fill(255);
    
    textAlign(CENTER, CENTER);
    text(message, pos_x + message_wx/2, pos_y + message_wy/2 - 0.2*textSize);
    messageFrame += 1;
    if(messageFrame >= messageAnimationLength){
      showMessage = false;
    }
    
    
  }
}
