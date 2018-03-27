import processing.video.*;

Movie movie;

String path;

StringList playList = new StringList();
StringList extensions = new StringList("mov", "mp4");

int playListCounter = 0;

void setup(){
  size(500, 500);
  frameRate(30);
  path = sketchPath() + "/data";
  
  updatePlaylist(path);
  
  if(playList.size() > 0){
    println(playList.get(0));
    movie = new Movie(this, playList.get(0));
  
    movie.play();
  }
  
  
}

void draw(){
  
  if(frameCount % 60 == 1){
    println("Check for files again.");
    updatePlaylist(path);
  }
  if(movie.available()){
    movie.read();
  }
  
  if(movie.time() >= movie.duration()){
    println("Finished playing movie.");
    playListCounter++;
    
    if(playListCounter > playList.size()-1){
      playListCounter = 0;
    }
    println("Playlist item: " + playListCounter);
    
    movie = new Movie(this, playList.get(playListCounter));
    movie.play();
  }
  image(movie, 0, 0, width, height);
}

void updatePlaylist(String dir){
  println("Updating playlist...");
  File file = new File(dir);
  if(file.isDirectory()){
    String names[] = file.list();
    for(int i = 0; i < names.length; i++){
      String fileName = names[i];
      
      if(extensions.hasValue(getFileExtension(fileName))){
        if(!playList.hasValue(fileName)){
          playList.append(fileName);
          
          println(fileName + " added to playlist");
        }
      }
    }
  }
}

String getFileExtension(String name){
  return name.substring(name.lastIndexOf(".")+1);
}