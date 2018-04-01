import deadpixel.keystone.*;
import gohai.glvideo.*;

Keystone ks;

ArrayList<Surface> surfaces = new ArrayList<Surface>();
ArrayList<GLMovie> movies = new ArrayList<GLMovie>();
ArrayList<PGraphics> buffers = new ArrayList<PGraphics>();

String assetsPath;

int playListIndex = 0;
StringList fileNames = new StringList();
StringList acceptedExtensions = new StringList("mov", "mp4");

// Show the information overlay?
boolean showInfo = false;

float watchRate = 1;

void setup() {
  size(800, 600, P3D);
  //fullScreen(P3D);

  ks = new Keystone(this);
  assetsPath = sketchPath() + "/data";
  loadVideos();
  
  //for(int i = 0; i < fileNames.size(); i++){
  //  movies.add(new GLMovie(this, fileNames.get(i)));
  //  buffers.add(createGraphics(400, 300, P2D));
  //}
  buffers.add(createGraphics(400, 300, P2D));
}

void draw() {
  if(frameCount % 60 == 1){
    println("Checking for new files.");
    loadVideos();
  }
  
  background(0);

  //for(int i = 0; i < movies.size(); i++){
  //  GLMovie currentMovie = movies.get(i);
  //  PGraphics currentBuffer = buffers.get(i);
    
  //  // If the movie has a new frame...
  //  if(currentMovie.available()){
  //    // Read it and draw it to the buffer
  //    currentMovie.read();
      
  //    currentBuffer.beginDraw();
  //    currentBuffer.image(currentMovie, 0, 0, 400, 300);
  //    currentBuffer.endDraw();
  //  }
    
  //  if(currentMovie.time() > 0 && !currentMovie.playing()){
  //    println("Done playing.");
  //  }
  //}
  
  GLMovie currentMovie = movies.get(0);
  PGraphics currentBuffer = buffers.get(0);
  
  if(currentMovie.available()){
    currentMovie.read();
    
    currentBuffer.beginDraw();
    currentBuffer.image(currentMovie, 0, 0, 400, 300);
    currentBuffer.endDraw();
  }
  
  if(currentMovie.time() > 0 && !currentMovie.playing()){
    println("Finished playing " + fileNames.get(playListIndex));
    //currentMovie.pause();
    //currentMovie.jump(0);
    playListIndex++;
    if(playListIndex >= fileNames.size()-1){
      playListIndex = 0;
    }
    //movies.get(playListIndex).play();
    println("Starting playback of " + fileNames.get(playListIndex));
    movies.remove(0);
    movies.add(new GLMovie(this, fileNames.get(playListIndex)));
    movies.get(0).play();
  }

  // Render all of the surfaces
  for(int i = 0; i < surfaces.size(); i++){
    surfaces.get(i).render();
  }
  
  // Put this at the very end so it shows on top of everything.
  if (showInfo) {
    showInfo();
  }
  
}

void addSurface(){
  println("Adding new surface...");
  //int index = (surfaces.size()+1) % buffers.size();
  int index = 0;
  Surface newSurface = new Surface();
  
  movies.get(index).play();
  newSurface.assignBuffer(buffers.get(index));
  
  surfaces.add(newSurface);
}

// Show the UI
void showInfo() {
  fill(0, 0, 0, 128);
  noStroke();
  rect(0, 0, width, height);

  fill(0, 255, 0);
  textSize(15);
  text("Info", 0, 20);

  text("show/hide info: i", 0, 40);
  text("add new surface: q", 0, 60);
  text("toggle mapping mode: m", 0, 80);
}

void myEos(){
}
