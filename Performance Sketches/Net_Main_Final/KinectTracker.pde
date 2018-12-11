class KinectTracker {

  Kinect2 kinect2;
  OpenCV opencv;

  PVector[] contourVertices;
  Contour biggestContour;
  int[] rawDepth;

  int verticesNum = 200;

  PImage defaultImg;
  PImage depthImg, blurImg;


  KinectTracker(PApplet pa, int num) {
    kinect2 = new Kinect2(pa);
    kinect2.initDepth();
    kinect2.initDevice();
    depthImg = new PImage(kinect2.depthWidth, kinect2.depthHeight, ARGB);
    blurImg = new PImage(kinect2.depthWidth, kinect2.depthHeight, ARGB);
    opencv = new OpenCV(pa, depthImg);
    defaultImg = new PImage(kinect2.depthWidth, kinect2.depthHeight, ARGB);
    defaultImg = loadImage("ren.jpg");

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
    int pixelCount = 0;
    for (int i=0; i < rawDepth.length; i++) {
      int depth = rawDepth[i];
      if (depth >= thresholdMin && depth <= thresholdMax && depth != 0) {
        depthImg.pixels[i] = color(255, 255);
        //pixelCount++;
      } else {
        depthImg.pixels[i] = color(0, 0);
      }
    }
    if(pixelCount>1000)depthImg.updatePixels();
    //depthImg = defaultImg;
    //println(defaultImg.width, defaultImg.height);
    //println(depthImg.width, depthImg.height);
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
    opencv.dilate();
    opencv.dilate();

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
    if (biggestContour != null && biggestContour.area()>6000) {
      //jump sampling the contour points to the target number
      ArrayList<PVector> ori = biggestContour.getPoints();
      int oriSize = ori.size();
      for (int i = 0; i < verticesNum; i++) {
        contourVertices[i] = (ori.get(int(map(i, 0, verticesNum-1, 0, oriSize-1))));
      }
    } else {
      for (int i = 0; i < verticesNum; i++) {
        contourVertices[i].set(256, 414);
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
