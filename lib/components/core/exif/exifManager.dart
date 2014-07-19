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
  /**
   *  Higher integer to represent data
   */ 
  double higherDateInformation = 0.0;

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
  double extractExifInformation(Photo photo){
    var dateToReturn = 0.0;
    
    //TODO extracts exif information
    
    //TODO return data normalized
    dateToReturn = firstNormalization(new DateTime(2)); //TODO change this
    
    return dateToReturn;
    
  }
  
  /**
   * Normalize Information 
   */ 
  double firstNormalization(DateTime date){
    var normalizationNumber = 0.0;
    
    //TODO do normalization
    normalizationNumber = 0.0;
    if(normalizationNumber > higherDateInformation){
      higherDateInformation = normalizationNumber;
    }
    
    return normalizationNumber;
  }
  
  double calcNormalizationNumber(double firstNormalizationNumber){
    return firstNormalizationNumber/higherDateInformation;
  }
  
  void secondNormalization(List<Photo> photos){
    for(Photo photo in photos){
      print(calcNormalizationNumber(photo.dataFromPhoto)); //TODO
      photo.setDataFromPhoto(calcNormalizationNumber(photo.dataFromPhoto));
    }  
  }
  
}