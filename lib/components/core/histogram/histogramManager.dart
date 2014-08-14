library histogrammanager;

import '../photo/photo.dart';
import 'package:observe/observe.dart';


class HistogramManager extends Object with Observable{
  
  static HistogramManager _instance; 

  HistogramManager._() {}

  static HistogramManager get() {
    if (_instance == null) {
      _instance = new HistogramManager._();
    }
    return _instance;
  }
  
  List<Photo> sortPhotosByHistogramDiff(List<Photo> photosToSort){
    var sortedList = new List<Photo>();
    sortedList.addAll(photosToSort);
    
    //photosToSort.sort((a, b) => (a.histogramDiff).compareTo(b.histogramDiff));
    
    return photosToSort;
  }
  
  Photo returnPhotoWithBestExposureLevel(List<Photo> photosToDecide){
    return sortPhotosByHistogramDiff(photosToDecide).first;
  }
  
  List<double> calculateBlackAndWhiteZone(List<int> redValues, List<int> greenValues, List<int> blueValues){
    
    var blackPixels = 0,
        lightPixels = 0,
        listSize = redValues.length,
        returnList = new List<double>();
    
    for(int i = 0; i < listSize; i++){
      
      //Red
      if(redValues.elementAt(i) < 128){
        blackPixels += 1;
      }else{
        lightPixels += 1;
      }
      
      //Green
      if(greenValues.elementAt(i) < 128){
        blackPixels += 1;
      }else{
        lightPixels += 1;
      }
      
      //blue
      if(blueValues.elementAt(i) < 128){
        blackPixels += 1;
      }else{
        lightPixels += 1;
      }
    }
    
    //Cause 3 channels
    blackPixels = blackPixels/3;
    lightPixels = lightPixels/3;
    
    //Normalization
    blackPixels = blackPixels/listSize;
    lightPixels = lightPixels/listSize;
    
    returnList.add(blackPixels);
    returnList.add(lightPixels);
    
    return returnList;
  }

  
  void receiveData(List<int> redValues, List<int> greenValues, List<int> blueValues, Photo photo){
    
    var blackAndWhiteList = calculateBlackAndWhiteZone(redValues, greenValues, blueValues),
        difference = 0.0;
    
    difference = blackAndWhiteList.elementAt(1) - blackAndWhiteList.elementAt(0);
    difference = difference.abs();
    
    print("Photo " + photo.title.toString() + ": Black percentage: " 
        + blackAndWhiteList.elementAt(0).toString() + "% and Light percentage: " 
        + blackAndWhiteList.elementAt(1).toString() + "%. Diff: " + difference.toString()); 
    
    photo.setHistogramDiff(difference); 
  }
  
}