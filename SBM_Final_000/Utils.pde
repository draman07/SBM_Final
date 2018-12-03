PVector[] updateContourPointsArray(PImage img, int target) {
  return simplifyArrayListTo(updateBiggestContourPoints(img), target);
}

ArrayList<PVector> updateBiggestContourPoints(PImage img) {
  opencv.loadImage(img);
  opencv.gray();
  opencv.dilate();
  opencv.erode();

  opencv.erode();
  opencv.dilate();

  ArrayList<Contour> contours = opencv.findContours();
  if (contours.size()>0) {
    Contour biggest = contours.get(0);
    for (Contour c : contours) {
      if (c.area()>biggest.area())
        biggest = c;
    }
    return biggest.getPoints();
  }
  return null;

  //}
  //return new ArrayList<PVector>();
}

PVector[] simplifyArrayListTo(ArrayList<PVector> ori, int target) {
  PVector[] simple = new PVector[target];
  int oriSize = ori.size();
  for (int i = 0; i < target; i++) {
    simple[i] = (ori.get(int(map(i, 0, target-1, 0, oriSize-1))));
  }
  return simple;
}

PVector averagePointInArray(PVector[] points) {
  PVector average = new PVector(0, 0, 0);
  for (int i = 0; i < points.length; i++) {
    average.add(points[i]);
  }
  return average.div(points.length);
}

PVector calculateNormal(PVector p, PVector pLast, PVector pNext) {

  PVector normal = PVector.add(PVector.sub(p, pLast), PVector.sub(p, pNext)).normalize();
  PVector lastToP = PVector.sub(p, pLast);
  PVector pToNext = PVector.sub(pNext, p);
  if (lastToP.heading() < pToNext.heading()) {
    normal.mult(-1);
  }

  return normal;
}
