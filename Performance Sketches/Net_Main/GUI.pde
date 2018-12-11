ControlP5 cp5;

boolean guiToggle;

int thresholdMin = 0;
int thresholdMax = 4499;

int numOfNetsDisplay = 1;
int numOfLinesDisplay = 0;

float normalOffset = 0, centerOffset = 5;

int humanOffsetX, humanOffsetY;
float centerOffsetY;

float lerpFactor = 0.2;
float flashFactor = 0.45;

void setupGui() {
  guiToggle = true;

  int sliderW = 100;
  int sliderH = 15;
  int startX = 10;
  int startY = 35;
  int spacing = 20;

  cp5 = new ControlP5( this );

  //cp5.addToggle("displayLines")
  //  .setPosition(10, startY+spacing*1)
  //  .setSize(sliderW, sliderH)
  //  .setValue(false);
  //cp5.addToggle("displayNet")
  //  .setPosition(10, startY+spacing*3)
  //  .setSize(sliderW, sliderH)
  //  .setValue(false);

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
  cp5.addSlider("humanOffsetX")
    .setPosition(10, startY+spacing*14)
    .setSize(sliderW, sliderH)
    .setRange(-width, width)
    .setValue((width-1024)/2)
    ; 
  cp5.addSlider("humanOffsetY")
    .setPosition(10, startY+spacing*15)
    .setSize(sliderW, sliderH)
    .setRange(-height, height)
    .setValue((height-828)/2)
    ;   
  cp5.addSlider("centerOffsetY")
    .setPosition(10, startY+spacing*17)
    .setSize(sliderW, sliderH)
    .setRange(-height, height)
    .setValue(0)
    ; 


  cp5.addSlider("numOfLinesDisplay")
    .setPosition(10, startY+spacing*19)
    .setSize(sliderW, sliderH)
    .setRange(0, 10)
    .setValue(0)
    ;  
  cp5.addSlider("numOfNetsDisplay")
    .setPosition(10, startY+spacing*20)
    .setSize(sliderW, sliderH)
    .setRange(1, 10)
    .setValue(1)
    ;
  cp5.addSlider("normalOffset")
    .setPosition(10, startY+spacing*21)
    .setSize(sliderW, sliderH)
    .setRange(-50, 50)
    .setValue(0)
    ;
  cp5.addSlider("centerOffset")
    .setPosition(10, startY+spacing*22)
    .setSize(sliderW, sliderH)
    .setRange(-50, 50)
    .setValue(0)
    ;

  cp5.addSlider("flashFactor")
    .setPosition(10, startY+spacing*23)
    .setSize(sliderW, sliderH)
    .setRange(0.45, 1)
    .setValue(0)
    ;
  cp5.addSlider("lerpFactor")
    .setPosition(10, startY+spacing*24)
    .setSize(sliderW, sliderH)
    .setRange(0.1, 1)
    .setValue(0.1)
    ;
  cp5.setAutoDraw(false);
}

void drawGui() {
  hint(DISABLE_DEPTH_TEST);
  cp5.draw();
}
