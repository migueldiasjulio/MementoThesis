library phototype;

import 'image.dart';

class Photo extends Image {

  static int _COUNT = 1;

  String id;
  Image _thumbnail;
  List<String> category;

  Photo(String src, {String title}) : id = "photo_${_COUNT++}", super(src);

  Image get thumbnail {
    if (_thumbnail == null) {
      _thumbnail = createThumbnail(256, 256);
    }
    return _thumbnail;
  }

  List<String> get returnCategory => this.category;

  void set setCategory(List<String> category) {
    this.category = category;
  }

  void addNewCategory(String _category){
    this.category.add(_category);
  }

  operator ==(other) => other.id == id;

}