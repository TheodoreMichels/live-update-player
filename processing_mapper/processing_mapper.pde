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

boolean noVideos = true;

float watchRate = 1;

void setup() {
  size(400, 300, P3D);
  //fullScreen(P3D);

  ks = new Keystone(this);
  ks.toggleCalibration(); // Start up showing calibration.

  assetsPath = sketchPath() + "/data";
  println("Loading files from " + assetsPath);
  updateVideoList();

  // Check to see if any files were found locally.
  if (fileNames.size() > 0) {
    playFirstMovie();
  } else {
    println("No valid local files were found.");
  }

  buffer = createGraphics(400, 300, P2D);
  surface = new Surface();
  surface.assignBuffer(buffer);
}

void draw() {
  if (frameCount % 120 == 1) {
    println("Checking for new files.");
    updateVideoList();
  }

  background(0);
  // If there's a frame available...
  if (!noVideos) {
    if (movie.available()) {
      // Read it and draw it to the buffer
      movie.read();
      // Off screen buffer
      buffer.beginDraw();
      buffer.image(movie, 0, 0, 400, 300);
      buffer.endDraw();
    }
  }

  if (!noVideos) {
    // If the movie has started (time > 0) but isn't playing, it must be done.
    if (movie.time() > 0 && !movie.playing()) {
      if(!(playListIndex >= fileNames.size())){
        println("Finished playing playlist index " + playListIndex + ":" + fileNames.get(playListIndex));
      }else{
        println("Playlist index out of bounds. A video was probably deleted.");
      }
      
      playListIndex++;
      // If the index is greater than the files array, reset it.
      if (playListIndex >= fileNames.size()) {
        playListIndex = 0;
      }

      println("Starting playback of playlist index " + playListIndex + " :" + fileNames.get(playListIndex));
      movie.dispose(); // Free up the resources from the movie.
      // Create a new movie from the next file name and play it.
      movie = new GLMovie(this, fileNames.get(playListIndex));
      movie.play();
    }
  }

  surface.render();

  if (noVideos) {
    textAlign(CENTER);
    fill(255, 0, 0);
    textSize(20);
    text("No local videos found.", width/2, height/2);
  }

  // Put this at the very end so it shows on top of everything.
  if (showInfo) {
    showInfo();
  }
}

void playFirstMovie() {
  movie = new GLMovie(this, fileNames.get(0));
  movie.play();
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
  text("toggle mapping mode: m", 0, 80);
}
