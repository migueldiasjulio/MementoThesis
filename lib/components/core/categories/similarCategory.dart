library similarcategory;

import 'category.dart';
import '../photo/photo.dart';
import 'dart:math';

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
  
  double calcDistance(List<double> descriptorPhoto, List<double> descriptorPhotoNow){
    var result;
    var size = descriptorPhoto.length;
    //Euclidean Distance
    var sum = 0.0;
    for(int i = 0; i < size; i++){
      var subtraction = (descriptorPhotoNow.elementAt(i) - descriptorPhoto.elementAt(i));
      subtraction = pow(subtraction, 2);
      sum += subtraction;
    }
    result = sqrt(sum);
    
    return result;
  }
  
  void euclideanDistance(Photo photo, List<Photo> allPhotos){
    var distanceToOtherPhotos = new List<double>();
    allPhotos.forEach((photoNow){
      distanceToOtherPhotos.add(calcDistance(photo.photoDescriptor, photoNow.photoDescriptor));
    });
    print("Distances of photo " + photo.title + " " + distanceToOtherPhotos.toString());
  }
  
  void work(List<Photo> photosToAnalyze){
    var distanceInformation;
    photosToAnalyze.forEach((photo){
      euclideanDistance(photo, photosToAnalyze);
    });
  }
}