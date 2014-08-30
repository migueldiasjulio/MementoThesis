library thirdauxfunctions;

import 'dart:html';
import 'package:observe/observe.dart';

class ThirdAuxFunctions extends Object with Observable{
  
  static ThirdAuxFunctions _instance; 
  String previousPhotoID = null,
         mainPhotoID = null;
  Element selectedPhoto = null,
          previousPhoto = null;
  @observable bool isInOverflow = false;
  

  ThirdAuxFunctions._(); 
  
  static ThirdAuxFunctions get() {
    if (_instance == null) {
      _instance = new ThirdAuxFunctions._();
    }
    return _instance;
  }
  
  bool setIfItIsInOverflow(bool overflow) => isInOverflow = overflow;  
  bool get isOverflowing => isInOverflow;
  
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