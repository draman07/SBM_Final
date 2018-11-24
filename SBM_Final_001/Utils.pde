Contour updateBiggestContour(PImage img){
  opencv.loadImage(img);
  opencv.gray();
  opencv.dilate();
  opencv.erode();
  opencv.erode();
  opencv.erode();
  opencv.erode();
  opencv.dilate();
  ArrayList<Contour> contours = opencv.findContours();
  
  Contour biggest = contours.get(0);
  for(Contour c: contours){
    if(c.area()>biggest.area())
    biggest = c;
  }
  return biggest;
}
