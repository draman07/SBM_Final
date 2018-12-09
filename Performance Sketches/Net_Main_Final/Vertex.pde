class Vertex{

  PVector pos, vel, acc;
  PVector targetPos;
  int index;
  
  Vertex(PVector position, int i){
    pos = position;
    targetPos = new PVector(0,0);
    index = i;
  }
  
  void update(){
    pos.lerp(targetPos, lerpFactor);
  }
  
  void setTargetPos(PVector t){
    targetPos = t;
  }
  
  PVector getPos(){
    return pos;
  }
  
  

}
