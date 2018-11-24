class Boid {
  PVector pos, vel, acc;
  PVector posNext;
  float r;
  float maxspeed, maxforce;
  int index;


  Boid(float x, float y, int i) {
    acc= new PVector(0, 0);
    vel = new PVector(random(-1, 1), random(-1, 1));
    pos = new PVector(x, y);
    r = 3.0;
    maxspeed = 3; //3.5;// 3;
    maxforce = .05; //0.05
    index = i;
  }

  void run(ArrayList<Boid> boids, ArrayList<PVector> bodyPoints) {
    tension(boids);
    //attractToCenter();
    PVector sep = separate(bodyPoints);
    sep.mult(5.5*1.2);
    applyForce(sep);
    PVector coh = cohesion(bodyPoints);
    applyForce(coh.mult(2));
    update();
    //borders();
    render();
  }
   PVector cohesion (ArrayList<PVector> points) {
    float neighbordist = 300; //50
    PVector sum = new PVector(0, 0);   // Start with empty vector to accumulate all positions
    int count = 0;
    for (PVector other : points) {
      float d = PVector.dist(pos, other);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other); // Add position
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      return seek(sum);  // Steer towards the position
    } else {
      return new PVector(0, 0);
    }
    
  }
    PVector seek(PVector target) {
    PVector desired = PVector.sub(target, pos);  // A vector pointing from the position to the target
    // Normalize desired and scale to maximum speed
    desired.normalize();
    desired.mult(maxspeed);
    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired, vel);
    steer.limit(maxforce);  // Limit to maximum steering force
    return steer;
  }
  PVector separate (ArrayList<PVector> points) {
    float desiredseparation = 40;//25.0f;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    // For every boid in the system, check if it's too close
    for (PVector other : points) {
      float d = PVector.dist(pos, other);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(pos, other);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) { //50
      //desiredseparation -= 10;//25.0f;
      steer.div((float)count);
    }
    //println(steer.mag());
    // As long as the vector is greater than 0
    if (steer.mag() > 0 ) {//&& steer.mag()<.01) {
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(vel);
      steer.limit(maxforce);
    }
    return steer;
  }
  void tension(ArrayList<Boid> boids) {
    int l = boids.size();
    Boid b1 = boids.get((index-1+l)%l);
    Boid b2 = boids.get((index+1+l)%l);
    PVector steer = new PVector(0, 0, 0);
    float dist1 = PVector.dist(pos, b1.pos);
    PVector diff1 = PVector.sub(pos, b1.pos).normalize().div(dist1);
    float dist2 = PVector.dist(pos, b2.pos);
    PVector diff2 = PVector.sub(pos, b2.pos).normalize().div(dist2);
    steer.add(diff1);
    steer.add(diff2);
    steer.div(2);
    steer.normalize();
    steer.mult(maxspeed);
    steer.sub(vel);
    steer.limit(maxforce);
    applyForce(steer.mult(1));
    posNext = b2.pos.copy();
  }
  void attractToCenter() {
    PVector toCenter = new PVector(width/2, height/2);
    toCenter.sub(pos);
    toCenter.normalize();
    toCenter.mult(maxspeed);
    toCenter.sub(vel);
    toCenter.limit(maxforce*2);
    applyForce(toCenter);
  }

  void update() {
    vel.add(acc);
    vel.limit(maxspeed);
    pos.add(vel);
    acc.mult(0);
  }

  void applyForce(PVector force) {
    acc.add(force);
  }
  void borders() {
    if (pos.x < -r) pos.x = width+r;
    if (pos.y < -r) pos.y = height+r;
    if (pos.x > width+r) pos.x = -r;
    if (pos.y > height+r) pos.y = -r;
  }

  void render() {
    pushStyle();
    fill(255);
    noStroke();
    ellipse(pos.x, pos.y, r, r);
    stroke(255);
    strokeWeight(2);
    line(pos.x, pos.y, posNext.x, posNext.y);
    popStyle();
  }
}
