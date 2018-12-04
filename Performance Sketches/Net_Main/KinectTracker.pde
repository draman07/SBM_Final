class KinectTracker {

  Kinect2 kinect2;
  OpenCV opencv;

  PVector[] contourVertices;
  Contour biggestContour;
  int[] rawDepth;

  int verticesNum = 200;

  PImage depthImg, blurImg;


  KinectTracker(PApplet pa, int num) {
    kinect2 = new Kinect2(pa);
    kinect2.initDepth();
    kinect2.initDevice();
    depthImg = new PImage(kinect2.depthWidth, kinect2.depthHeight, ARGB);
    blurImg = new PImage(kinect2.depthWidth, kinect2.depthHeight, ARGB);
    opencv = new OpenCV(pa, depthImg);

    verticesNum = num;
    contourVertices = new PVector[num];
    for (int i = 0; i < num; i++) {
      contourVertices[i] = new PVector(0, 0);
    }
  }

  void update() {
    updateDepthImg();
    updateOpenCV();
    updateBiggestContour();
    updateContourPoints();
  }

  void updateDepthImg() {
    rawDepth = kinect2.getRawDepth();
    depthImg.loadPixels();
    for (int i=0; i < rawDepth.length; i++) {
      int depth = rawDepth[i];
      if (depth >= thresholdMin && depth <= thresholdMax && depth != 0) {
        depthImg.pixels[i] = color(255, 255);
      } else {
        depthImg.pixels[i] = color(0, 0);
      }
    }
    depthImg.updatePixels();
    //image(depthImg,512,0);
  }

  void updateOpenCV() {
    opencv.loadImage(depthImg);
    opencv.gray();
    //opencv.threshold(50);
    opencv.erode();
    opencv.dilate();
    opencv.dilate();
    opencv.erode();
    opencv.blur(10);
    blurImg = opencv.getSnapshot();
    
  }

  void updateBiggestContour() {
    ArrayList<Contour> contours = opencv.findContours();
    if (contours.size()>0) {
      biggestContour = contours.get(0);
      for (Contour c : contours) {
        if (c.area()>biggestContour.area())
          biggestContour = c;
      }
    }
  }

  void updateContourPoints() {
    if (biggestContour != null) {
      //jump sampling the contour points to the target number
      ArrayList<PVector> ori = biggestContour.getPoints();
      int oriSize = ori.size();
      for (int i = 0; i < verticesNum; i++) {
        contourVertices[i] = (ori.get(int(map(i, 0, verticesNum-1, 0, oriSize-1))));
      }
    }
  }

  void setThresholds(int min, int max) {
    thresholdMin = min;
    thresholdMax = max;
  }

  PImage getDepthImage() {
    return depthImg;
  }
  PVector[] getContourVertices() {
    return contourVertices;
  }
  PImage getBlurImage() {
    return blurImg;
  }
}
