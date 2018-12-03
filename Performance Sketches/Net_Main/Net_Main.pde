import org.openkinect.processing.*;
import gab.opencv.*;
import controlP5.*;
import oscP5.*;
import netP5.*;

KinectTracker tracker;
PGraphics netsGraphics;
PGraphics humanGraphics;
PImage humanImg;

Net[] nets;

int numOfPoints = 500; // the number of vertices on each nets
int numOfNets = 10;  // the number of layers of the nets

float scaleFactor;  //the scale factor from the kinect size to the sketch size

OscP5 oscP5;

void setup() {
  size(1024, 828, P2D);
  tracker = new KinectTracker(this, numOfPoints);
  netsGraphics = createGraphics(width, height, P2D);
  humanGraphics = createGraphics(width, height, P2D);
  humanImg = createImage(512, 414, ARGB);

  scaleFactor = width/512;

  setupGui();

  oscP5 = new OscP5(this, 12000);

  nets = new Net[numOfNets];
  for (int i = 0; i < numOfNets; i++) {
    if (i == 0) nets[i] = new Net(numOfPoints, null, tracker);
    else nets[i] = new Net(numOfPoints, nets[i-1], null);
  }
}


void draw() {
  background(0, 255);

  //update kinect tracker
  tracker.update(); 
  humanImg = tracker.getBlurImage();

  //drawing nets on the nets pgraphics
  netsGraphics.beginDraw();
  netsGraphics.clear();
  netsGraphics.scale(scaleFactor);
  for (int i = 0; i < numOfNets; i++) {
    nets[i].update();
    if (i < numOfLinesDisplay)nets[i].displayLines();
    else if (i == numOfNetsDisplay)nets[i].displayNet();
  }
  netsGraphics.endDraw();

  //drawing the human image onto the pgraphics for scaling up
  humanGraphics.beginDraw();
  humanGraphics.clear();
  humanGraphics.image(humanImg, 0, 0, width, height);
  humanGraphics.endDraw();

  //pixel manipulation to change the white pixels on the human to black ones
  humanGraphics.loadPixels();
  netsGraphics.loadPixels();
  for (int i = 0; i < 512 * 414; i++) {
    if (humanGraphics.pixels[i] == color(255, 255) 
      && brightness(netsGraphics.pixels[i]) > 5) {
      netsGraphics.pixels[i] = color(0);
    }
  }
  netsGraphics.updatePixels();

  if (random(flashFactor)<0.5)image(humanGraphics, 0, 0);
  image(netsGraphics, 0, 0);


  if (guiToggle)drawGui();
}

void keyPressed() {
  if (key == ' ')guiToggle =!guiToggle;
}
