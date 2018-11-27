ControlP5 cp5;

boolean guiToggle;

int normalOffset, centerOffset;

void setupGui() {
  guiToggle = true;

  int sliderW = 100;
  int sliderH = 15;
  int startX = 10;
  int startY = 35;
  int spacing = 20;

  cp5 = new ControlP5( this );

  cp5.addSlider("thresholdMin")
    .setPosition(10, startY+spacing*11)
    .setSize(sliderW, sliderH)
    .setRange(1, 4499)
    .setValue(0)
    ; 

  cp5.addSlider("thresholdMax")
    .setPosition(10, startY+spacing*12)
    .setSize(sliderW, sliderH)
    .setRange(1, 4499)
    .setValue(4499)
    ; 

  cp5.addSlider("numOfNetsDisplay")
    .setPosition(10, startY+spacing*14)
    .setSize(sliderW, sliderH)
    .setRange(1, 10)
    .setValue(1)
    ;
  cp5.addSlider("normalOffset")
    .setPosition(10, startY+spacing*15)
    .setSize(sliderW, sliderH)
    .setRange(-50, 50)
    .setValue(0)
    ;
  cp5.addSlider("centerOffset")
    .setPosition(10, startY+spacing*16)
    .setSize(sliderW, sliderH)
    .setRange(-50, 50)
    .setValue(0)
    ;

  cp5.setAutoDraw(false);
}

void drawGui() {
  hint(DISABLE_DEPTH_TEST);
  cp5.draw();
}
