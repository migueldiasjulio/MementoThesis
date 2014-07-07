library colorcategory;

import 'category.dart';
import '../photo/photo.dart';

class ColorCategory extends Category{
  
  static ColorCategory _instance;

  static ColorCategory get() {
    if (_instance == null) {
      _instance = new ColorCategory._();
    }
    return _instance;
  }
  
  ColorCategory._() : super("COLOR"){
    //TODO
  }
  
  void work(List<Photo> photosToAnalyze){
    //NOTHING IS NEEDED
  }
}