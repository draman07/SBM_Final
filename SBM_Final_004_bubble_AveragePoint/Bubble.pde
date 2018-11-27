class Bubble {
  PShape s;
  float x, y;
  float yoff = 0;
  PVector pos;
  float scale;

  ArrayList<PVector> original;

  Bubble(float x, float y) {
    pos = new PVector(x, y);
    
    //scale the bubble???
    float dist = dist(tracker.lerpedLoc.x, tracker.lerpedLoc.y, tracker.loc.x*sumX, tracker.loc.y*sumY);
    scale = map(dist, 0, 100, 0, 10);

    original = new ArrayList<PVector>();
    for (float a = 0; a < TWO_PI; a+=0.2) {
      PVector v = PVector.fromAngle(a);
      v.mult(100);
      original.add(v);
    }

    s = createShape();
    s.beginShape();
    s.fill(255, 100);
    s.stroke(0);
    s.strokeWeight(2);
    for (PVector v : original) {
      s.vertex(v.x, v.y);
    }
    s.endShape(CLOSE);
  }

  void wiggle() {
    float xoff = 0;
    for (int i = 0; i < s.getVertexCount(); i++) {
      PVector pos = original.get(i);
      float a = TWO_PI*noise(xoff, yoff);
      PVector r = PVector.fromAngle(a);
      r.mult(4);
      r.add(pos);
      s.setVertex(i, r.x, r.y*1.5);
      xoff+= 0.5;
    }
    yoff += 0.02;
  }

  void update() {
    pos.x = tracker.lerpedLoc.x;
    pos.y = tracker.lerpedLoc.y;
    
    
  }

  void display() {
    pushMatrix();
    translate(pos.x, pos.y);
    shape(s);
    popMatrix();
    //println(pos.x);
  }
}
