library thirdauxfunctions;

import 'dart:html';
import 'package:observe/observe.dart';
import '../../../core/photo/GroupOfPhotos/groupOfPhotos.dart';
import '../../defaultScreen/screenModule.dart' as screenhelper;
import '../../../core/photo/photo.dart';
import '../../../core/database/dataBase.dart';
export "package:polymer/init.dart";
import '../../../core/categories/category.dart';

class ThirdAuxFunctions extends Object with Observable{
  
  static ThirdAuxFunctions _instance; 
  String previousPhotoID = null,
         mainPhotoID = null;
  Element selectedPhoto = null,
          previousPhoto = null;
  
  ThirdAuxFunctions._(); 
  
  static ThirdAuxFunctions get() {
    if (_instance == null) {
      _instance = new ThirdAuxFunctions._();
    }
    return _instance;
  }
    
  void cleanElementSelected() {
    if (selectedPhoto != null) {selectedPhoto.classes.remove('choosed');}
  }
  
  void markPhotoWithElement(Element element) {
    previousPhoto = selectedPhoto;
    selectedPhoto = element;
    if (previousPhoto != null) {
      previousPhoto.classes.remove('choosed');
      selectedPhoto.classes.add('choosed');
    } else {
      selectedPhoto.classes.add('choosed');
    }
  }
  
}