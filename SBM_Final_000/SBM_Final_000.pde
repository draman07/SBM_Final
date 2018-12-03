int num = 1000;
PVector[] bodyPoints;
PVector[] netPoints;
PVector[] netNetPoints;
PVector[] netNetNetPoints;

void setup() {
  size(512, 414, P2D);
  setupGui();
  setupKinect();
  //bodyPoints = updateContourPointsArray(depthImg, num);
  netPoints = new PVector[num];
  netNetPoints = new PVector[num];
  netNetNetPoints = new PVector[num];
  for (int i = 0; i < num; i++) {
    netPoints[i] = new PVector(random(width), random(height)); 
    netNetPoints[i] = new PVector(random(width), random(height));
    netNetNetPoints[i] = new PVector(random(width), random(height));
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

      stroke(120);
      strokeWeight(1);
      line(netPoints[i].x, netPoints[i].y, p.x, p.y);
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

      stroke(200);
      strokeWeight(1);
      line(netNetPoints[i].x, netNetPoints[i].y, p.x, p.y);
    }
    for (int i = 0; i < num; i++) {
      PVector p = netNetPoints[i];
      PVector target = p.copy();
      PVector pLast = netNetPoints[(i-1+num)%num]; 
      PVector pNext = netNetPoints[(i+1+num)%num];
      PVector normal = calculateNormal(p, pLast, pNext);
      PVector fromCenter = PVector.sub(p, average).normalize();
      target.add(normal.mult(random(normalOffset-20, normalOffset+20)));
      target.add(fromCenter.mult(random(centerOffset-20, centerOffset+20)));
      netNetNetPoints[i].lerp(target, 0.1);

      if (displayNetVertices) {
        stroke(255, 0, 0);
        strokeWeight(5);
        point(netNetNetPoints[i].x, netNetNetPoints[i].y);
      }
      if (displayNet) {
        stroke(255, 0, 0);
        strokeWeight(2);
        if (i!=0) {
          line(netNetNetPoints[i].x, netNetNetPoints[i].y, netNetNetPoints[i-1].x, netNetNetPoints[i-1].y);
        }else{
          line(netNetNetPoints[i].x, netNetNetPoints[i].y, netNetNetPoints[num-1].x, netNetNetPoints[num-1].y);
        }
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
        line(netNetNetPoints[i].x, netNetNetPoints[i].y, p.x, p.y);
      }
    }
    drawGui();
  }
}
