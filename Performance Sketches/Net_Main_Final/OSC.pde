void oscEvent(OscMessage msg) {
  numOfNetsDisplay = (int)msg.get(0).floatValue();
  numOfLinesDisplay = (int)msg.get(1).floatValue();
  normalOffset = msg.get(2).floatValue();
  centerOffset = msg.get(3).floatValue();
  lerpFactor = msg.get(4).floatValue();
  flashFactor = msg.get(5).floatValue();
  strokeColor = msg.get(6).intValue();
  ended = msg.get(7).intValue();
}
