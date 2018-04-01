import deadpixel.keystone.*;
import gohai.glvideo.*;

Keystone ks;

Surface surface;

GLMovie movie;
PGraphics buffer;

String assetsPath;

int playListIndex = 0;
StringList fileNames = new StringList();
StringList acceptedExtensions = new StringList("mov", "mp4");

// Show the information overlay?
boolean showInfo = false;

float watchRate = 1;

void setup() {
  size(400, 300, P3D);
  //fullScreen(P3D);

  ks = new Keystone(this);
  assetsPath = sketchPath() + "/data";
  loadVideos();
  
  movie = new GLMovie(this, fileNames.get(0));
  movie.play();

  buffer = createGraphics(400, 300, P2D);
  surface = new Surface();
  surface.assignBuffer(buffer);
}

void draw() {
  if(frameCount % 60 == 1){
    println("Checking for new files.");
    loadVideos();
  }
  
  background(0);
  
  if(movie.available()){
    movie.read();
    
    buffer.beginDraw();
    buffer.image(movie, 0, 0, 400, 300);
    buffer.endDraw();
  }
  
  if(movie.time() > 0 && !movie.playing()){
    println("Finished playing " + fileNames.get(playListIndex));

    playListIndex++;
    println("Playlist index: " + playListIndex);
    if(playListIndex >= fileNames.size()){
      playListIndex = 0;
    }

    println("Starting playback of " + fileNames.get(playListIndex));
    movie.dispose();
    movie = new GLMovie(this, fileNames.get(playListIndex));
    movie.play();
  }
  
  surface.render();
  
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
