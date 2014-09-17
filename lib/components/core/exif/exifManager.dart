library exifManager;

import '../photo/photo.dart';
import 'dart:js';
import 'package:observe/observe.dart';
import 'package:js/js.dart' as js;

class ReturnObject{
  double valueToSave;
  int year,
      month,
      day,
      hour,
      minutes,
      seconds,
      milliseconds;
  ReturnObject(double valueToSave, int year, int month, int day, int hour,
               int minutes, int seconds, int milliseconds){
    this.valueToSave = valueToSave;
    this.year = year;
    this.month = month;
    this.day = day;
    this.hour = hour;
    this.minutes = minutes;
    this.seconds = seconds;
    this.milliseconds = milliseconds;
  } 
}

class ExifManager extends Object with Observable {
  
  /**
   * Singleton
   */
  static ExifManager _instance; 
  /**
   *  Higher integer to represent data
   */ 
  double higherDateInformation = 1.0;

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
   * Normalize Information 
   */ 
  ReturnObject firstNormalization(DateTime date){
    var normalizationNumber = 0.0,
        year = date.year,
        month = date.month,
        day = date.day,
        hour = date.hour,
        minutes = date.minute,
        seconds = date.second,
        milliseconds = date.millisecond;
    
    normalizationNumber = (year*10000000.0) + (month*1000000.0) + (day*100000.0) + 
                          (hour*10000.0) + (minutes*100.0) + seconds;
    
    if(normalizationNumber > higherDateInformation){higherDateInformation = normalizationNumber;}
        
    return new ReturnObject(normalizationNumber,year, month, day, hour, minutes, seconds, milliseconds);
  }
  
  double calcNormalizationNumber(double firstNormalizationNumber){
     return firstNormalizationNumber/higherDateInformation;
  }
  
  void secondNormalization(List<Photo> photos){
    for(Photo photo in photos){
      photo.setSecondsDataInformation(calcNormalizationNumber(photo.dataFromPhoto));
    }  
  }
  
}