import oscP5.*;
import netP5.*;
import processing.sound.*;

OscP5 oscP5;
NetAddress dest;

FFT fft;
AudioIn in;
SoundFile file;
int bands = 512;
float[] spectrum = new float[bands];
boolean stopPlaying = false;
float amp = 0.5;

int state = -1;
boolean displayNet, displayLines;
float numOfNetsDisplay, numOfLinesDisplay;
float normalOffset = 0, centerOffset = -20;
float lerpFactor, flashFactor;
int strokeColor;
int ended = 0;

void setup() {
  size(200, 200);
  oscP5 = new OscP5(this, 1234);
  dest = new NetAddress("10.225.80.185", 12000); //Mars Loc

  fft = new FFT(this, bands);
  in = new AudioIn(this, 0);
  file = new SoundFile(this, "music.wav");
  file.amp(amp);
  // start the Audio Input
  in.start();

  // patch the AudioIn
  fft.input(in);
}

void draw() {
  background(0);
  textSize(50);
  text(state, width/2, height/2);
  textSize(15);
  text("P to play\nN to pause", 10, 15);

  processAudio();

  if (state == -1) {
    numOfNetsDisplay = lerp(numOfNetsDisplay, -1, 0.1);
    numOfLinesDisplay =  lerp(numOfLinesDisplay, -1, 0.1);
    normalOffset = lerp(normalOffset, 0, .1); 
    centerOffset = lerp(centerOffset, -10, .1); // -infinity
    lerpFactor = .3;
    flashFactor = 0.45;
    strokeColor = int(lerp(strokeColor, color(255, 0), 0.2));
  } else if (state == 0) {
    numOfNetsDisplay =  lerp(numOfNetsDisplay, 0, 0.1);
    numOfLinesDisplay =  lerp(numOfLinesDisplay, 4, 0.1);

    normalOffset = lerp(normalOffset, -10, .1); 
    centerOffset = lerp(centerOffset, -10, .1); // -infinity
    lerpFactor = .3;
    flashFactor = 0.45;
    strokeColor = lerpColor(strokeColor, color(0), 0.2);
  } else if (state == 1) {
    numOfNetsDisplay = 9;
    numOfLinesDisplay = 0;
    normalOffset = lerp(normalOffset, 8, .1); 
    centerOffset = lerp(centerOffset, 5, .1); // -infinity
    lerpFactor = .3;
    flashFactor = 0.45;
    strokeColor = lerpColor(strokeColor, color(255), 0.2);
  } else if (state == 2) {
    numOfNetsDisplay = 9;
    numOfLinesDisplay = 0;
    normalOffset = lerp(normalOffset, 8, .1);
    centerOffset = lerp(centerOffset, 5, .1);
    lerpFactor = .2;
    flashFactor = lerp(flashFactor, 0.6, 0.1);
    strokeColor = lerpColor(strokeColor, color(255), 0.2);
  } else if ( state == 3) {
    numOfNetsDisplay = 9;
    numOfLinesDisplay = 0;
    normalOffset = lerp(normalOffset, 8, .1);
    centerOffset = lerp(centerOffset, 5, .1);
    lerpFactor = lerp(lerpFactor, .5, 0.1);
    flashFactor = lerp(flashFactor, 1.0, 0.1);
    strokeColor = lerpColor(strokeColor, color(255), 0.2);
  } else if (state == 4) {
    numOfNetsDisplay = 0;
    numOfLinesDisplay = lerp(numOfLinesDisplay, 9, 0.1);
    normalOffset = lerp(normalOffset, 12, .1);
    centerOffset = lerp(centerOffset, 12, .1);
    lerpFactor = lerp(lerpFactor, .2, 0.1);
    flashFactor = lerp(flashFactor, 1.0, 0.1);
    strokeColor = lerpColor(strokeColor, color(255), 0.2);
  } else if (state == 5) {
    numOfNetsDisplay = 0;
    numOfLinesDisplay = 9;
    normalOffset = lerp(normalOffset, -12, .1);
    centerOffset = lerp(centerOffset, -12, .1);
    lerpFactor = lerp(lerpFactor, .6, 0.1);
    flashFactor = lerp(flashFactor, 0, 0.1);
    strokeColor = lerpColor(strokeColor, color(255), 0.2);
  }

  OscMessage msg = new OscMessage("/state");
  msg.add( numOfNetsDisplay );
  msg.add( numOfLinesDisplay );

  msg.add( 1*normalOffset * (1 + 10*audioOffset));
  msg.add( 1*centerOffset + (1 + 20*audioOffset));
  msg.add( lerpFactor );
  msg.add( flashFactor );
  msg.add( strokeColor );
  msg.add( ended);


  oscP5.send(msg, dest);

  if (stopPlaying) {
    amp = lerp(amp, 0, 0.1);
    file.amp(amp);
    if (amp == 0) {
      stopPlaying = false;
      file.stop();
    }
  }
}

void keyPressed() {

  if (key == ' ') {
    println("-1");
    state = -1;
  } else if (key == '0') {
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
  } else if (key == 'p') {
    file.play();
  } else if (key == 'n') {
    stopPlaying = true;
  }  else if(key == 'e'){
    ended = 1;
  }
}
