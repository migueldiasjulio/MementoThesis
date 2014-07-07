library categorymanager;

import '../photo/photo.dart';
import 'facesCategory.dart' as faces;
import 'blackAndWhiteCategory.dart' as bw;
import 'colorCategory.dart' as color;
import 'similarCategory.dart' as similar;
import 'category.dart';
import 'package:observe/observe.dart';

class CategoryManager extends Object with Observable {
  
  /**
   * Singleton
   */
  static CategoryManager _instance; 
  final List<Category> categories = toObservable(new Set());

  CategoryManager._() {
    categories.add(faces.FacesCategory.get());
    categories.add(bw.BlackAndWhiteCategory.get());
    categories.add(color.ColorCategory.get());
    categories.add(similar.SimilarCategory.get());
  }

  static CategoryManager get() {
    if (_instance == null) {
      _instance = new CategoryManager._();
    }
    return _instance;
  }
  
  /**
   * Pipeline to extract categories from photos
   */ 
  void categoriesPipeline(List<Photo> photosToAnalyze){
    if(photosToAnalyze.length > 0){
      categories.forEach((category){
        category.work(photosToAnalyze);
      }); 
    }
  }
}