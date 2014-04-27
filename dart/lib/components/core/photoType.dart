import 'dart:html';

class photoType {
  
  File originalPhotoPath;
  ImageElement thumbnailPhotoPath;
  
  //TODO I need to change this to an enumerator!!!!!!!
  String classification;
  List<String> category;
  
  photoType(File originalPhotoPath, ImageElement thumbnailPhotoPath){
    this.originalPhotoPath = originalPhotoPath;
    this.thumbnailPhotoPath = thumbnailPhotoPath;
  }
  
  String get returnClassification => this.classification;
  
  void set setClassification(String classification) {
    this.classification = classification;
  }
  
  List<String> get returnCategory => this.category;
  
  void set setCategory(List<String> category) {
    this.category = category;
  }
  
  void addNewCategory(String _category){
    this.category.add(_category);
  }

}