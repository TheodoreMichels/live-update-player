import deadpixel.keystone.*;
import gohai.glvideo.*;

Keystone ks;
GLMovie movie;

CornerPinSurface surface;
PGraphics buffer;

void setup() {
  size(400, 300, P3D);

  ks = new Keystone(this);

  surface = ks.createCornerPinSurface(400, 300, 20);
  buffer = createGraphics(400, 300, P2D);
  movie = new GLMovie(this, "triangle.mp4");
  movie.loop();
}

void draw() {
  background(0);

  if (movie.available()) {
    movie.read();

    buffer.beginDraw();
    buffer.background(128);
    buffer.image(movie, 0, 0, 400, 300);
    buffer.endDraw();
  }
  surface.render(buffer);
}

void keyPressed() {
  switch(key) {
  case 'c':
    ks.toggleCalibration();
    break;
  }
}
