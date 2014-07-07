library category;

import 'package:observe/observe.dart';
import '../photo/photo.dart';

abstract class Category extends Object with Observable {
  final String name;
  
  Category(this.name);
  
  void work(List<Photo> photosToAnalyse);
}
