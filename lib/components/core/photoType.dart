import 'dart:html';

class photoType {
  
  File myFile;
  ImageElement myThumbnail;
  
  //TODO I need to change this to an enumerator!!!!!!!
  //String classification = "STANDBY";
  List<String> category;
  
  photoType(File myFile, ImageElement myThumbnail){
    this.myFile = myFile;
    this.myThumbnail = myThumbnail;
  }
  
  //String get returnClassification => this.classification;
  
  /*void set setClassification(String classification) {
    this.classification = classification;
  }*/
  
  List<String> get returnCategory => this.category;
  
  void set setCategory(List<String> category) {
    this.category = category;
  }
  
  void addNewCategory(String _category){
    this.category.add(_category);
  }

}