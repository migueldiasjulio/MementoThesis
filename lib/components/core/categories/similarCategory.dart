library similarcategory;

import 'category.dart';
import '../photo/photo.dart';
import '../photo/GroupOfPhotos/similarGroupOfPhotos.dart';
import 'dart:math';

class SimilarCategory extends Category{
  
  static SimilarCategory _instance;
  final double _thresholdDistance = 50.0;
  final double _almostTheSame = 10.0;
  final double _samePhotoDistance = 0.0;
  List<SimilarGroupOfPhotos> _similarGroups = null;

  static SimilarCategory get() {
    if (_instance == null) {
      _instance = new SimilarCategory._();
    }
    return _instance;
  }
  
  SimilarCategory._() : super("SIMILAR"){}
  
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
    });

    var size = distanceToOtherPhotos.length,
        photosToAdd = new List<Photo>(),
        almostTheSame = new List<Photo>();
    for(int i = 0; i < size; i++){
      if(distanceToOtherPhotos.elementAt(i) != _samePhotoDistance 
          && distanceToOtherPhotos.elementAt(i) < _thresholdDistance){
        photosToAdd.add(allPhotos.elementAt(i));
      }
      if(distanceToOtherPhotos.elementAt(i) < _almostTheSame &&
          distanceToOtherPhotos.elementAt(i) != _samePhotoDistance){
        almostTheSame.add(allPhotos.elementAt(i));
      }
    }
    
    photo.addSimilarPhotos(photosToAdd);
    photo.almostTheSamePhoto.addAll(almostTheSame);
  }
  
  List<SimilarGroupOfPhotos> workSimilarCase(List<Photo> photos){
   var similarGroupOfPhotos = null,   
   auxOne = new List<Photo>(),
   similarGroupList = new List<SimilarGroupOfPhotos>();
   
   photos.forEach((photo){
    if(!auxOne.contains(photo) && (photo.similarPhotos.length > 0)){
      similarGroupOfPhotos = new SimilarGroupOfPhotos();
      similarGroupOfPhotos.setGroupName("Similar");
      similarGroupOfPhotos.setGroupFace(photo);
      similarGroupOfPhotos.addToList(photo);
      photo.setSimilarGroup(similarGroupOfPhotos);
      auxOne.add(photo);
      
      photo.similarPhotos.forEach((similar){
        if(!auxOne.contains(similar) && photos.contains(similar)){
          auxOne.add(similar);
          similarGroupOfPhotos.addToList(similar);
          similar.setSimilarGroup(similarGroupOfPhotos);
          
          similar.similarPhotos.forEach((similarOfSimilar){
            if(!auxOne.contains(similarOfSimilar) && photos.contains(similarOfSimilar)){
              auxOne.add(similarOfSimilar);
              similarGroupOfPhotos.addToList(similarOfSimilar);
              similarOfSimilar.setSimilarGroup(similarGroupOfPhotos);
            }
          });
        }
      }); 
      
      if(similarGroupOfPhotos.giveMeAllPhotos.length > 1){similarGroupList.add(similarGroupOfPhotos);}
    }
   });
   
   similarGroupList.sort();
   similarGroupList = similarGroupList.reversed.toList();
   
   return similarGroupList;
  }
    
  void work(List<Photo> photosToAnalyze){ 
    photosToAnalyze.forEach((photo){
      euclideanDistance(photo, photosToAnalyze); 
    });  
  }
  
}