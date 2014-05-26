library phototype;

import 'dart:html';
import 'Thumbnail.dart';

class photoType {
  
  String mySrc;
  Thumbnail myThumbnail;
  List<String> category;
  
  photoType(String mySrc, Thumbnail myThumbnail){
    this.mySrc = mySrc;
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