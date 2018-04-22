import oscP5.*;
import netP5.*;
String value1;
String value2;

// To forskellige OSC objekter, til at sende hver deres besked:
OscP5 oscP5;
OscP5 oscP52;
NetAddress myRemoteLocation;

void setup() {
  size(400,400);
  frameRate(25);
  oscP5 = new OscP5(this,1234);
  oscP52 = new OscP5(this,1234);

  myRemoteLocation = new NetAddress("127.0.0.1", 5005);
}

void draw() {
  background(0);
   if(value1 != null){
    textAlign(CENTER);
    fill(200);
    stroke(255);
    textSize(15);
    text("Random værdier fra Python:", width/2, height/2+100);
    textSize(20);
    text(float(value1)*10, width/2, height/2+120);
    noStroke();
    fill(255,0,0);
    ellipse(200,120,float(value1)*width,height*float(value1));
    
    }
   if(value2 != null){
    textSize(20);
    textSize(15);
    text(value2, width/2, height/2+140);
    value2 = null;
  }
}

void keyPressed() {
  OscMessage myMessage = new OscMessage("/miklokey");
  myMessage.add("1st haha");
  oscP52.send(myMessage, myRemoteLocation);
  print("sender besked key");
}

void mousePressed(){
  OscMessage myMessage = new OscMessage("/miklo");
  
  /* Man kan tilføje int, float, text, byte OG arrays*/
  // Denne beskedID indeholder 3 beskeder, hvilket skal tages i mente
  // for den modtagende handler-funktion
  myMessage.add("1st lol");
  myMessage.add("2nd lol");
  myMessage.add("3rd lol");

  /* Hvad der sendes, og hvor til */
  oscP5.send(myMessage, myRemoteLocation);
  print("sender besked");
}

void oscEvent(OscMessage theOscMessage) {
  // Således ser det ud for modtagelse af kun én OSC besked:
  value1 = theOscMessage.get(0).stringValue();
  print(" value1: "+value1);
  
  // Man kan også tjekke på OSC-ID og laver handlinger ud fra hvert ID:
  if(theOscMessage.checkAddrPattern("/keypressed")==true) {
    value2 = theOscMessage.get(0).stringValue();
   }
}
