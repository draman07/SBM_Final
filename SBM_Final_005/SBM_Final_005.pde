import org.openkinect.processing.*;
import gab.opencv.*;
import controlP5.*;

KinectTracker tracker;
PGraphics netsGraphics;
PImage depthImg;

Net[] nets;

int numOfPoints = 200;
int numOfNets = 10;

int numOfNetsDisplay = 1;

int thresholdMin = 0;
int thresholdMax = 4499;



void setup() {
  size(1024, 828, P2D);
  tracker = new KinectTracker(this, numOfPoints);
  netsGraphics = createGraphics(512, 414, P2D);
  depthImg = createImage(512, 414, ARGB);
  setupGui();
  nets = new Net[numOfNets];
  for (int i = 0; i < numOfNets; i++) {
    if (i == 0) nets[i] = new Net(numOfPoints, null, tracker);
    else nets[i] = new Net(numOfPoints, nets[i-1], null);
  }
}


void draw() {
  background(0, 255);

  tracker.update(); 
  depthImg = tracker.getDepthImage();

  netsGraphics.beginDraw();
  netsGraphics.clear();
  //netsGraphics.scale(2);
  for (int i = 0; i < numOfNets; i++) {
    nets[i].update();
    if (i < numOfNetsDisplay)nets[i].display();
  }
  netsGraphics.endDraw();

  depthImg.loadPixels();
  netsGraphics.loadPixels();
  for (int i = 0; i < 512 * 414; i++) {
    if (depthImg.pixels[i] == color(255, 255) 
      && brightness(netsGraphics.pixels[i]) > 5) {
      netsGraphics.pixels[i] = color(0);
    }
  }
  netsGraphics.updatePixels();



  pushMatrix();
  scale(2);
  image(depthImg, 0, 0);
  image(netsGraphics, 0, 0);
  popMatrix();
  


  if (guiToggle)drawGui();
}

void keyPressed() {
  if (key == ' ')guiToggle =!guiToggle;
}
