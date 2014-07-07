library facescategory;

import 'category.dart';
import '../photo/photo.dart';

class FacesCategory extends Category{
  
  static FacesCategory _instance;

  static FacesCategory get() {
    if (_instance == null) {
      _instance = new FacesCategory._();
    }
    return _instance;
  }
  
  FacesCategory._() : super("FACES"){
    //TODO
  }
  
  void work(List<Photo> photosToAnalyze){
    photosToAnalyze.forEach((photo){
      photo.addNewCategory(_instance);
    });
    //TODO DO SOMETHING
  }
}