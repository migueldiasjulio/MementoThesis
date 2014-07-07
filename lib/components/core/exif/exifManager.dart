library exifManager;

import '../photo/photo.dart';
import 'dart:js';
import 'package:observe/observe.dart';

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
  void extractExifInformation(){
    //TODO
  }
  
  /**
   * Normalize Information 
   */ 
  void normalizeInformation(){
    //TODO
  }
  
  /**
   * Sort Photos
   */
  void sortPhotos(){
    //TODO
  }
  
}