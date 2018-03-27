import processing.video.*;

String path;

ArrayList<Movie> movies = new ArrayList<Movie>();
Movie currentMovie;

StringList playList = new StringList();
StringList extensions = new StringList("mov", "mp4");

int playListCounter = 0;

boolean noVideos = false;

void setup(){
  size(500, 500);
  frameRate(30);
  path = sketchPath() + "/data";
  println("Video directory: " + path);
  
  println("Checking for existing videos...");
  updatePlaylist(path);
  
  if(playList.size() > 0){
    initPlaylist();
  }else{
    noVideos = true;
    println("No existing videos found in target directory.");
  }
}

void draw(){
  if(frameCount % 60 == 1){
    println("Checking for new files.");
    updatePlaylist(path);
  }
  
  if(noVideos){
    background(0);
    color(255, 0, 0);
    fill(255, 0, 0);
    textSize(20);
    textAlign(CENTER);
    text("No videos found in target directory.", width/2, height/2);
    
    if(playList.size() > 0){
      initPlaylist();
      noVideos = false;
    };
    return;
  }
  
  if(currentMovie.available()){
    currentMovie.read();
  }
  
  if(currentMovie.time() >= currentMovie.duration()){
    println("Finished playing "+playList.get(playListCounter)+".");
    playListCounter++;
    
    if(playListCounter > playList.size()-1){
      playListCounter = 0;
    }
    println("Playlist item: " + playListCounter);
    
    currentMovie.stop();
    currentMovie = movies.get(playListCounter);
    currentMovie.play();
  }
  image(currentMovie, 0, 0, width, height);
}

void initPlaylist(){
  println("Initializing playlist...");
  println("Playing first item: " + playList.get(0));
  
  currentMovie = movies.get(0);

  currentMovie.play();
}

void updatePlaylist(String dir){
  File file = new File(dir);
  if(file.isDirectory()){
    boolean newFound = false;
    
    String names[] = file.list();
    for(int i = 0; i < names.length; i++){
      String fileName = names[i];
      
      if(extensions.hasValue(getFileExtension(fileName))){
        if(!playList.hasValue(fileName)){
          newFound = true;
          println("New File found. Updating playlist...");
          playList.append(fileName);
          
          movies.add(new Movie(this, fileName));
          
          println(fileName + " added to playlist");
        }
      }
    }
    if(!newFound){
      println("No new files found.");
    }
  }
}

String getFileExtension(String name){
  return name.substring(name.lastIndexOf(".")+1);
}
