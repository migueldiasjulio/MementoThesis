library phototype;

import 'image.dart';
import '../categories/category.dart';

class Photo extends Image {

  static int _COUNT = 1;

  String id;
  Image _thumbnail;
  List<Category> _categories;
  List<Photo> _almostTheSamePhotos;
  List<Photo> _similarPhotos;
  

  Photo(String src, {String title}) : id = "photo_${_COUNT++}", 
                                      _almostTheSamePhotos = new List<Photo>(), 
                                      _similarPhotos = new List<Photo>(), 
                                      _categories = new List<Category>(),
                                      super(src);

  Image get thumbnail {
    if (_thumbnail == null) {
      _thumbnail = createThumbnail(256, 256);
    }
    return _thumbnail;
  }
  
  List<Photo> get almostTheSamePhoto => _almostTheSamePhotos;
  List<Photo> get similarPhotos => _similarPhotos;
  List<Category> get returnCategory => this._categories;
  
  bool containsCategory(Category category){
    return _categories.contains(category);
  }

  void set setCategories(List<Category> categories) {
    this._categories = categories;
  }

  void addNewCategory(Category _category){
    this._categories.add(_category);
  }

  operator ==(other) => other.id == id;

}