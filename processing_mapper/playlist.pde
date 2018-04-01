void loadVideos(){
  //println("Loading files from " + assetsPath);
  File directory = new File(assetsPath);
  // Check to see if it's actually a directory.
  if(directory.isDirectory()){
    String files[] = directory.list();
    
    for(int i = 0; i < files.length; i++){
      
      // Check to see if the file has one of the accepted extensions
      if(acceptedExtensions.hasValue(getFileExtension(files[i]))){
        if(!fileNames.hasValue(files[i])){
          println("Adding " + files[i] + " to playlist.");
          // And add it to the list if it does
          fileNames.append(files[i]);
        }
      }
    }
  }
}

String getFileExtension(String name){
  return name.substring(name.lastIndexOf(".")+1);
}
