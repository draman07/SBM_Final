int num = 500;
PVector[] bodyPoints;
PVector[] netPoints;
PVector[] netNetPoints;

void setup() {
  size(512, 414, P2D);
  setupGui();
  setupKinect();
  //bodyPoints = updateContourPointsArray(depthImg, num);
  netPoints = new PVector[num];
  netNetPoints = new PVector[num];
  for (int i = 0; i < num; i++) {
    netPoints[i] = new PVector(random(width), random(height)); 
    netNetPoints[i] = new PVector(random(width), random(height));
  }
}

void draw() {
  background(0);
  runKinect();
  if (frameCount>2) {
    bodyPoints = updateContourPointsArray(depthImg, num);
    PVector average = averagePointInArray(bodyPoints);
    for (int i = 0; i < num; i++) {
      PVector p = bodyPoints[i];
      PVector target = p.copy();
      PVector pLast = bodyPoints[(i-1+num)%num]; 
      PVector pNext = bodyPoints[(i+1+num)%num];
      PVector normal = calculateNormal(p, pLast, pNext);
      PVector fromCenter = PVector.sub(p, average).normalize();
      target.add(normal.mult(random(normalOffset-20, normalOffset+20)));
      target.add(fromCenter.mult(random(centerOffset-20, centerOffset+20)));
      netPoints[i].lerp(target, 0.1);


      if (displayNetVertices) {
        stroke(255, 0, 0);
        strokeWeight(5);
        point(netPoints[i].x, netPoints[i].y);
      }
      if (displayNet) {
        stroke(255, 0, 0);
        strokeWeight(2);
        line(netPoints[i].x, netPoints[i].y, netPoints[(i+1+num)%num].x, netPoints[(i+1+num)%num].y);
      }
      if (displayBody) {
        stroke(255);
        strokeWeight(2);
        line(p.x, p.y, pNext.x, pNext.y);
      }
      if (displayBodyVertices) {
        stroke(255);
        strokeWeight(5);
        point(p.x, p.y);
      }
      if (displayBodyToNet) {
        stroke(255);
        strokeWeight(1);
        line(netPoints[i].x, netPoints[i].y, p.x, p.y);
      }
    }
    for (int i = 0; i < num; i++) {
      PVector p = netPoints[i];
      PVector target = p.copy();
      PVector pLast = netPoints[(i-1+num)%num]; 
      PVector pNext = netPoints[(i+1+num)%num];
      PVector normal = calculateNormal(p, pLast, pNext);
      PVector fromCenter = PVector.sub(p, average).normalize();
      target.add(normal.mult(random(normalOffset-20, normalOffset+20)));
      target.add(fromCenter.mult(random(centerOffset-20, centerOffset+20)));
      netNetPoints[i].lerp(target, 0.1);


//      if (displayNetVertices) {
//        stroke(255, 0, 0);
//        strokeWeight(5);
//        point(netPoints[i].x, netPoints[i].y);
//      }
//      if (displayNet) {
//        stroke(255, 0, 0);
//        strokeWeight(2);
//        line(netPoints[i].x, netPoints[i].y, netPoints[(i+1+num)%num].x, netPoints[(i+1+num)%num].y);
//      }
//      if (displayBody) {
//        stroke(255);
//        strokeWeight(2);
//        line(p.x, p.y, pNext.x, pNext.y);
//      }
//      if (displayBodyVertices) {
//        stroke(255);
//        strokeWeight(5);
//        point(p.x, p.y);
//      }
      if (true) {
        stroke(255);
        strokeWeight(1);
        line(netNetPoints[i].x, netNetPoints[i].y, p.x, p.y);
      }
    }
    drawGui();
  }
}
