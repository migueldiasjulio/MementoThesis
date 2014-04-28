library phototype;

import 'dart:html';
import 'Thumbnail.dart';

class photoType {
  
  File myFile;
  Thumbnail myThumbnail;
  List<String> category;
  
  photoType(File myFile, Thumbnail myThumbnail){
    this.myFile = myFile;
    this.myThumbnail = myThumbnail;
  }
  
  List<String> get returnCategory => this.category;
  
  void set setCategory(List<String> category) {
    this.category = category;
  }
  
  void addNewCategory(String _category){
    this.category.add(_category);
  }

}