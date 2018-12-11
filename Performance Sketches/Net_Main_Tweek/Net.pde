class Net {

  Net innerNet;
  KinectTracker innerTracker;

  int num;
  Vertex[] vertices; 

  PVector[] innerVertices;
  PVector[] netVertices;

  //float normalOffset, centerOffset;

  Net(int num, Net n, KinectTracker kt) {
    this.num = num;
    vertices = new Vertex[num];
    innerVertices = new PVector[num];
    netVertices = new PVector[num];

    innerNet = n;
    innerTracker = kt;
    //normalOffset = 40;
    //centerOffset = 40;

    for (int i = 0; i < num; i++) {
      vertices[i] = new Vertex(new PVector(random(width), random(height)), i);
      innerVertices[i] = new PVector(0, 0, 0);
    }
  }

  void update() {
    updateInnerVertices();
    updateTargetVertices();
    updateNetVertices();
  }

  void displayLines() {
    for (int i = 0; i < num; i++) {
      netsGraphics.stroke(strokeColor);
      netsGraphics.strokeWeight(1);
      netsGraphics.line(innerVertices[i].x*scaleFactor, innerVertices[i].y*scaleFactor, netVertices[i].x*scaleFactor, netVertices[i].y*scaleFactor);
    }
  }
  void displayNet() {
    netsGraphics.stroke(strokeColor);
    netsGraphics.strokeWeight(1);
    netsGraphics.noFill();
    netsGraphics.beginShape();
    for (int i = 0; i < num; i++) {
      netsGraphics.curveVertex(innerVertices[i].x*scaleFactor, innerVertices[i].y*scaleFactor);
    }
    netsGraphics.endShape(CLOSE);
  }
  void updateInnerVertices() {
    if (innerNet != null) innerVertices = innerNet.getNetVertices();
    else innerVertices = innerTracker.getContourVertices();
  }



  void updateTargetVertices() {
    PVector average = averagePointInArray(innerVertices);
    average.y+=centerOffsetY;
    //average.add(0, -100);
    for (int i = 0; i < num; i++) {
      PVector p = innerVertices[i];
      PVector target = p.copy();
      PVector pLast = innerVertices[(i-1+num)%num]; 
      PVector pNext = innerVertices[(i+1+num)%num];
      PVector normal = calculateNormal(p, pLast, pNext);
      PVector fromCenter = PVector.sub(p, average).normalize();
      target.add(normal.mult(random(normalOffset-5, normalOffset+5)));
      target.add(fromCenter.mult(random(centerOffset-20, centerOffset+20)));

      vertices[i].setTargetPos(target);
    }
  }

  void updateNetVertices() {
    for (int i = 0; i < num; i++) {
      vertices[i].update();
      netVertices[i] = vertices[i].getPos();
    }
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

  PVector[] getNetVertices() {
    return netVertices;
  }
}
