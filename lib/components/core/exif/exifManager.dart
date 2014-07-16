library exifManager;

import '../photo/photo.dart';
import 'dart:js';
import 'package:observe/observe.dart';
import 'package:js/js.dart' as js;

class ExifManager extends Object with Observable {
  
  /**
   * Singleton
   */
  static ExifManager _instance; 

  ExifManager._() {
    //TODO
  }

  static ExifManager get() {
    if (_instance == null) {
      _instance = new ExifManager._();
    }
    return _instance;
  }
  
  /**
   * Extract EXIF Information 
   */ 
  void extractExifInformation(Photo photo){
    
    var exif = new JsObject(context['EXIF'], []);
    print(exif.callMethod('test', ['Funciona assim!']));
    
  }
  
  /**
   * Normalize Information 
   */ 
  int normalizeInformation(DateTime date){
    
    return 0;
  }
  
  /**
   * Sort Photos
   */
  void sortPhotos(){
    //TODO
  }
  
}