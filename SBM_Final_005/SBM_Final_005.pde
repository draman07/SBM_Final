import org.openkinect.processing.*;
import gab.opencv.*;
import controlP5.*;

KinectTracker tracker;

Net[] nets;

int numOfPoints = 200;
int numOfNets = 10;

int numOfNetsDisplay = 1;

int thresholdMin = 0;
int thresholdMax = 4499;

void setup() {
  size(1024, 414, P2D);
  tracker = new KinectTracker(this, numOfPoints);
  setupGui();
  nets = new Net[numOfNets];
  for (int i = 0; i < numOfNets; i++) {
    if (i == 0) nets[i] = new Net(numOfPoints, null, tracker);
    else nets[i] = new Net(numOfPoints, nets[i-1], null);
  }
}


void draw() {
  background(0);
  tracker.update(); 
  image(tracker.getDepthImage(), 512, 0);
  //image(tracker.getOpenCVImage(), 1024, 0);
  for (int i = 0; i < numOfNetsDisplay; i++) {
    nets[i].update();
    nets[i].display();
  }
  if(guiToggle)drawGui();
}

void keyPressed(){
  if(key == ' ')guiToggle =!guiToggle;
}
