float audioOffset = 0;
float audioOffsetTemp;

void processAudio(){
  audioOffsetTemp = 0;
  fft.analyze(spectrum);
  for(int i = 0; i< bands; i++){
    audioOffsetTemp+=spectrum[i];
  }
  //audioOffset /= bands;
  audioOffset = lerp(audioOffset,audioOffsetTemp,0.4);
  //println(audioOffset);
}
