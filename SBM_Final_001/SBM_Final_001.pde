import java.awt.Rectangle;
import gab.opencv.*;

PImage human;
ArrayList<Boid> boids;
ArrayList<PVector> points;
Contour c;
OpenCV opencv;
void setup() {
  size(648, 480);
  human = loadImage("human.jpg");
  opencv = new OpenCV(this, 640, 480);

  boids = new ArrayList();
  for (int i = 0; i < 14*5; i++) {
    if (i < 5*5) boids.add(new Boid(i*width/5/5, 0, i)); 
    else if (i < 7*5) boids.add(new Boid(width, (i-4*5)*height/3/5, i));
    else if (i < 12*5) boids.add(new Boid(width-(i-7*5)*width/5/5, height, i));
    else boids.add(new Boid(0, height - (i-11*5)*height/3/5, i));
  }
}
void draw() {
  background(0);
  c = updateBiggestContour(human);
  ArrayList<PVector> temp = c.getPoints();
  ArrayList<PVector> points = new ArrayList();
  for(int i = 0; i < temp.size();i+=5){
    points.add(temp.get(i));
  }
  strokeWeight(4);
  stroke(255, 0, 0);
  for ( PVector point : points) {
    int x = (int)point.x;
    int y = (int)point.y;
    point(x, y);
  }



  //println(count);


  //human.loadPixels();
  //PVector average = new PVector(0,0,0);
  //int count = 0;
  //for (int j = 0; j < human.height; j++) {
  //  for (int i = 0; i < human.width; i++) {
  //    int index = i + human.height * j;
  //    if(brightness(human.pixels[index]) > 100){
  //    average.add(i,j);
  //    count++;
  //    }
  //  }
  //}
  //average.div(count);
  //ellipse(average.x,average.y,10,10);

  for (Boid b : boids) {
    b.run(boids,points);
  }
}
