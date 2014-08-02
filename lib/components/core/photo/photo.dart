library phototype;

import 'image.dart';
import 'similarGroupOfPhotos.dart';
import '../categories/category.dart';

class Photo extends Image implements Comparable<Photo> {

  static int _COUNT = 1;

  String id;
  String title;
  String _mainSrc;
  double _dataInformation = 0.0;
  Image _thumbnail;
  Image _thumbnailToShow; 
  bool _isColor;
  bool _hasFaces = false;
  List<Category> _categories;
  List<Photo> _similarPhotos;
  List<double> _descriptor;
  SimilarGroupOfPhotos _similarGroup = null;
  
  Photo(String src, String title) : id = "photo_${_COUNT++}", 
                                    title = title,
                                    _mainSrc = src,
                                    _similarPhotos = new List<Photo>(), 
                                    _categories = new List<Category>(),
                                    super(src);

  Image get thumbnail {
    if (_thumbnail == null) {
      _thumbnail = createThumbnail(256, 256);
    }
    return _thumbnail;
  }
  
  Image get thumbnailToShow {
    if (_thumbnailToShow == null) {
      _thumbnailToShow = createThumbnailToShow();
    }
    return _thumbnailToShow;
  }
  
  List<Photo> get similarPhotos => _similarPhotos;
  List<Category> get returnCategory => _categories;
  double get dataFromPhoto => _dataInformation;
  String get mainSrc => _mainSrc;
  List<double> get photoDescriptor => _descriptor;
  bool get isColor => _isColor;
  bool get hasFaces => _hasFaces;
  SimilarGroupOfPhotos get returnSimilarGroup => _similarGroup;
  
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
  
  void thisOneIsColor(){
    _isColor = true;
  }
  
  void thisOneHasFaces(){
    _hasFaces = true;
  }
  
  void setSimilarGroup(SimilarGroupOfPhotos similarGroup){
    _similarGroup = similarGroup;
  }
  
  void removeSimilarGroup(){
    _similarGroup = null;
  }
  
  void addSimilarPhotos(List<Photo> photos){
    similarPhotos.addAll(photos);
  }
  
  void setDescriptor(List<double> newDescriptor){
    _descriptor = newDescriptor;
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