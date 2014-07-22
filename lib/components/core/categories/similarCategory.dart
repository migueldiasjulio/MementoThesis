library similarcategory;

import 'category.dart';
import '../photo/photo.dart';
import 'dart:math';

class SimilarCategory extends Category{
  
  static SimilarCategory _instance;
  final double _thresholdDistance = 50.0;
  final double _samePhotoDistance = 0.0;

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
    var result,
        size = descriptorPhoto.length,
        sum = 0.0,
        subtraction;
    for(int i = 0; i < size; i++){
      subtraction = (descriptorPhotoNow.elementAt(i) - descriptorPhoto.elementAt(i));
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
      print("Distance to others: " + distanceToOtherPhotos.toString());
    });
    
    var size = distanceToOtherPhotos.length,
        photosToAdd = new List<Photo>();
    for(int i = 0; i < size; i++){
      if(distanceToOtherPhotos.elementAt(i) != _samePhotoDistance 
          && distanceToOtherPhotos.elementAt(i) < _thresholdDistance){
        photosToAdd.add(allPhotos.elementAt(i));
        
        print("Added to " + photo.title + ": " + allPhotos.elementAt(i).title + " with distance: " 
            + distanceToOtherPhotos.elementAt(i).toString());
      }
    }
    
    photo.addSimilarPhotos(photosToAdd);
  }
  
  void applyCategory(Photo photo){
    photo.similarPhotos.forEach((similarPhoto){
      similarPhoto.addNewCategory(this);
    });
    
  }
  
  void work(List<Photo> photosToAnalyze){
    var distanceInformation;
    photosToAnalyze.forEach((photo){
      euclideanDistance(photo, photosToAnalyze);
      applyCategory(photo);
    });
  }
}