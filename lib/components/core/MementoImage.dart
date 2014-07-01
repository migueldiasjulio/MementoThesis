library phototype;

import 'dart:html';

class MementoImage {

  ImageElement _thumbnail;
  String _src, _title;
  List<String> _categories;

  MementoImage(String src, String title, ImageElement myThumbnail){
    this._src = src;
    this._title = title;
    this._thumbnail = myThumbnail;
  }

  List<String> get myCategories => this._categories;
  String get imageSrc => this._src;
  String get imageTitle => this._title;
  ImageElement get imageThumb => this._thumbnail;
  
  void setSrc(String src){
    this._src = src;
  }
  
  void setTitle(String title){
    this._title = title;
  }

  void addNewCategory(String _category){
    this._categories.add(_category);
  }
  
}
