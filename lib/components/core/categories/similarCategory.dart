library similarcategory;

import 'category.dart';
import '../photo/photo.dart';

class SimilarCategory extends Category{
  
  static SimilarCategory _instance;

  static SimilarCategory get() {
    if (_instance == null) {
      _instance = new SimilarCategory._();
    }
    return _instance;
  }
  
  SimilarCategory._() : super("SIMILAR"){
    //TODO
  }
  
  void work(List<Photo> photosToAnalyze){
    //TODO classify that photos with similar ones
  }
}