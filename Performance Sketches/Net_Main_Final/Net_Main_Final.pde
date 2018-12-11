import codeanticode.syphon.*;
import processing.video.*;

import org.openkinect.processing.*;
import gab.opencv.*;
import controlP5.*;
import oscP5.*;
import netP5.*;

SyphonServer server;
Movie myMovie;
int ended = 0; // 0 means not playing and 1 means playing
boolean playVideo = false;

PGraphics canvas;

KinectTracker tracker;
PGraphics netsGraphics;
PImage humanImg;

Net[] nets;

int numOfPoints = 500; // the number of vertices on each nets
int numOfNets = 10;  // the number of layers of the nets

float scaleFactor;  //the scale factor from the kinect size to the sketch size

int strokeColor = color(255);

OscP5 oscP5;

void setup() {
  size(1024, 828, P2D);
  canvas = createGraphics(1024, 828, P2D);
  tracker = new KinectTracker(this, numOfPoints);
  netsGraphics = createGraphics(512, 414, P2D);
  humanImg = createImage(512, 414, ARGB);

  scaleFactor = 1;

  setupGui();

  oscP5 = new OscP5(this, 12000);

  nets = new Net[numOfNets];
  for (int i = 0; i < numOfNets; i++) {
    if (i == 0) nets[i] = new Net(numOfPoints, null, tracker);
    else nets[i] = new Net(numOfPoints, nets[i-1], null);
  }

  server = new SyphonServer(this, "Processing Syphon");

  myMovie = new Movie(this, "ending.mp4");
}


void draw() {
  background(0, 255);

  //println(frameRate);
  //update kinect tracker
  tracker.update(); 
  humanImg = tracker.getBlurImage();

  //drawing nets on the nets pgraphics
  netsGraphics.beginDraw();
  netsGraphics.clear();
  //netsGraphics.scale(2);
  for (int i = 0; i < numOfNets; i++) {
    nets[i].update();
    if (i < numOfLinesDisplay)nets[i].displayLines();
    else if (i == numOfNetsDisplay)nets[i].displayNet();
  }
  netsGraphics.endDraw();


  //pixel manipulation to change the white pixels on the human to black ones
  if (normalOffset<-3) {
    humanImg.loadPixels();
    netsGraphics.loadPixels();
    for (int i = 0; i < 512*414; i++) {
      if (humanImg.pixels[i] == color(255, 255)
        && brightness(netsGraphics.pixels[i])>5) {
        netsGraphics.pixels[i] = color(0);
      }
    }
    netsGraphics.updatePixels();
  }
  //humanGraphics.updatePixels();


  canvas.beginDraw();
  canvas.background(0);
  canvas.scale(2);
  if (random(flashFactor)<0.5)canvas.image(humanImg, 0, 0);
  canvas.image(netsGraphics, 0, 0);
  if (mapping)canvas.background(255);
  if (playVideo)canvas.image(myMovie, 0, 0);
  canvas.endDraw();

  image(canvas, 0, 0);
  image(myMovie, 0, 0);
  server.sendImage(canvas);

  if (ended == 1 && !playVideo) {
    myMovie.play();
    playVideo = true;
  }

  if (guiToggle)drawGui();
}

boolean mapping = false;
void keyPressed() {
  if (key == ' ')guiToggle =!guiToggle;
  if (key == 'm') mapping = !mapping;
}

void movieEvent(Movie m) {
  m.read();
}
