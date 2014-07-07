library blackandwhitecategory;

import 'category.dart';
import '../photo/photo.dart';

class BlackAndWhiteCategory extends Category{
  
  static BlackAndWhiteCategory _instance;

  static BlackAndWhiteCategory get() {
    if (_instance == null) {
      _instance = new BlackAndWhiteCategory._();
    }
    return _instance;
  }
  
  BlackAndWhiteCategory._() : super("BLACKANDWHITE"){
    //TODO
  }
  
  void work(List<Photo> photosToAnalyze){
    photosToAnalyze.first.addNewCategory(_instance);
    /*photosToAnalyze.forEach((photo){
      photo.addNewCategory(this);
    }); */
    //TODO DO SOMETHING
  }
}