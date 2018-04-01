void keyPressed() {
  switch(key) {
  case 'm':
    ks.toggleCalibration();
    break;

  case 'l':
    // loads the saved layout
    ks.load();
    break;

  case 's':
    // saves the layout
    ks.save();
    break;

  case 'q':
    break;

    // Show the info overlay
  case 'i':
    println("Showing info.");
    showInfo = !showInfo;
    break;
  }
}
