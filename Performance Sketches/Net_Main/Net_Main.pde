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

int numOfPoints = 500;
int numOfNets = 10;

int numOfNetsDisplay = 1;
int numOfLinesDisplay = 0;

int thresholdMin = 0;
int thresholdMax = 4499;

float scaleFactor;

OscP5 oscP5;



void setup() {
  size(1024, 828, P2D);
  tracker = new KinectTracker(this, numOfPoints);
  netsGraphics = createGraphics(width, height, P2D);
  humanGraphics = createGraphics(width, height, P2D);
  humanImg = createImage(512, 414, ARGB);
  setupGui();

  scaleFactor = width/512;

  oscP5 = new OscP5(this, 12000);

  nets = new Net[numOfNets];
  for (int i = 0; i < numOfNets; i++) {
    if (i == 0) nets[i] = new Net(numOfPoints, null, tracker);
    else nets[i] = new Net(numOfPoints, nets[i-1], null);
  }
}


void draw() {
  background(0, 255);

  tracker.update(); 
  humanImg = tracker.getBlurImage();

  netsGraphics.beginDraw();
  netsGraphics.clear();
  netsGraphics.scale(scaleFactor);
  for (int i = 0; i < numOfNets; i++) {
    nets[i].update();
    if (i < numOfLinesDisplay)nets[i].displayLines();
    else if (i == numOfNetsDisplay)nets[i].displayNet();
  }
  netsGraphics.endDraw();

  humanGraphics.beginDraw();
  humanGraphics.clear();
  humanGraphics.image(humanImg, 0,0,width,height);

  humanGraphics.loadPixels();
  netsGraphics.loadPixels();
  for (int i = 0; i < 512 * 414; i++) {
    if (humanGraphics.pixels[i] == color(255, 255) 
      && brightness(netsGraphics.pixels[i]) > 5) {
      netsGraphics.pixels[i] = color(0);
    }
  }
  netsGraphics.updatePixels();


  pushMatrix();
  if (random(flashFactor)<0.5)image(humanGraphics, 0, 0);
  image(netsGraphics, 0, 0);
  popMatrix();

  //update();

  if (guiToggle)drawGui();
}

void keyPressed() {
  if (key == ' ')guiToggle =!guiToggle;
}
