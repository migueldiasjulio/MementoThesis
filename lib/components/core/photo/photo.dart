library phototype;

import 'image.dart';
import '../categories/category.dart';

class Photo extends Image implements Comparable<Photo> {

  static int _COUNT = 1;

  String id;
  double _dataInformation = 0.0;
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
  List<Category> get returnCategory => _categories;
  double get dataFromPhoto => _dataInformation;
  
  
  int compareTo(Photo o) {
    var result;
    if (o == null || o.dataFromPhoto == null) {
      result = -1;
    } else if (o.dataFromPhoto == null) {
      result = 1;
    } else {
      result = dataFromPhoto.compareTo(o.dataFromPhoto);
    }

    return result;
  }
  
  void setDataFromPhoto(double newDataPhoto){
    _dataInformation = newDataPhoto;
  }
  
  bool containsCategory(Category category){
    return _categories.contains(category);
  }

  void set setCategories(List<Category> categories) {
    this._categories = categories;
  }

  void addNewCategory(Category _category){
    this._categories.add(_category);
  }

  operator ==(other) => other.id == id; //&& other._dataInformation == _dataInformation; TODO

}