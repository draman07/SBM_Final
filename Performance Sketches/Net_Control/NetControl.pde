import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress dest;

int state;
boolean displayNet, displayLines;
float numOfNetsDisplay, numOfLinesDisplay;
float normalOffset = 0, centerOffset = -20;
float lerpFactor, flashFactor;

void setup() {
  size(100, 100);
  oscP5 = new OscP5(this, 1234);
  dest = new NetAddress("127.0.0.1", 12000); //Mars Loc
}

void draw() {
  if (state == 0) {
    numOfNetsDisplay = lerp(numOfNetsDisplay, 0, 0.1);
    numOfLinesDisplay =  lerp(numOfLinesDisplay, 0, 0.1);
    normalOffset = lerp(normalOffset, 0, .1); 
    centerOffset = lerp(centerOffset, -10, .1); // -infinity
    lerpFactor = .3;
    flashFactor = 0.45;
  } else if (state == 1) {
    numOfNetsDisplay = 9;
    numOfLinesDisplay = 0;
    normalOffset = lerp(normalOffset, 8, .1); 
    centerOffset = lerp(centerOffset, 5, .1); // -infinity
    lerpFactor = .3;
    flashFactor = 0.45;
  } else if (state == 2) {
    numOfNetsDisplay = 9;
    numOfLinesDisplay = 0;
    normalOffset = lerp(normalOffset, 8, .1);
    centerOffset = lerp(centerOffset, 5, .1);
    lerpFactor = .2;
    flashFactor = lerp(flashFactor, 0.6, 0.1);
  } else if ( state == 3) {
    numOfNetsDisplay = 9;
    numOfLinesDisplay = 0;
    normalOffset = lerp(normalOffset, 8, .1);
    centerOffset = lerp(centerOffset, 5, .1);
    lerpFactor = lerp(lerpFactor, .5, 0.1);
    flashFactor = lerp(flashFactor, 1.0, 0.1);
  } else if (state == 4) {
    numOfNetsDisplay = 0;
    numOfLinesDisplay = lerp(numOfLinesDisplay, 9, 0.1);
    normalOffset = lerp(normalOffset, 12, .1);
    centerOffset = lerp(centerOffset, 12, .1);
    lerpFactor = lerp(lerpFactor, .2, 0.1);
    flashFactor = lerp(flashFactor, 1.0, 0.1);
  } else if (state == 5) {
    numOfNetsDisplay = 0;
    numOfLinesDisplay = 9;
    normalOffset = lerp(normalOffset, -12, .1);
    centerOffset = lerp(centerOffset, -12, .1);
    lerpFactor = lerp(lerpFactor, .2, 0.1);
    flashFactor = lerp(flashFactor, 0, 0.1);
  }

  OscMessage msg = new OscMessage("/state");
  msg.add( numOfNetsDisplay );
  msg.add( numOfLinesDisplay );
  msg.add( normalOffset );
  msg.add( centerOffset );
  msg.add( lerpFactor );
  msg.add( flashFactor );

  oscP5.send(msg, dest);
}

void keyPressed() {


  if (key == '0') {
    println('0');
    state = 0;
  } else if (key == '1') {
    println('1');
    state = 1;
  } else if (key == '2') {
    println('2');
    state = 2;
  } else if (key == '3') {
    println('3');
    state = 3;
  } else if (key == '4') {
    println('4');
    state = 4;
  } else if (key == '5') {
    println('5');
    state = 5;
  } else {
    //
  }
}
