class Surface{
  
  CornerPinSurface surface;
  PGraphics associatedBuffer;
  
  Surface(){
    surface = ks.createCornerPinSurface(400, 300, 10);
  }
  
  void render(){
    surface.render(associatedBuffer);
  }
  
  void assignBuffer(PGraphics _associatedBuffer){
    associatedBuffer = _associatedBuffer;
  }
}
