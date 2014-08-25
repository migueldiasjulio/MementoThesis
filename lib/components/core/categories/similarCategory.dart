library similarcategory;

import 'category.dart';
import '../photo/photo.dart';
import '../photo/similarGroupOfPhotos.dart';
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
      if(distanceToOtherPhotos.elementAt(i) < _almostTheSame){
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
      similarGroupOfPhotos.addToList(photo);
      similarGroupOfPhotos.setGroupFace(photo);
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
      
      similarGroupList.add(similarGroupOfPhotos);
    }
   });

   similarGroupList.forEach((similarGroup){
     print("ANOTHER GROUP WITH FACE: " + similarGroup.groupFace.id);
     similarGroup.giveMeAllPhotos.forEach((photo){
       print("Photo: " + photo.id);
     });
   });
   //SORT HERE
   
   return similarGroupList;
  }
  
  List<List<Photo>> sortBySize(List<List<Photo>> listsToSort){
    var maxSize = 0;
    var listLength = 0;
    listsToSort.forEach((list){
      listLength = list.length;
      if(listLength > maxSize){
        maxSize = listLength;
        //putInTheCorrectLocation(list);
      }
    });
    return new List<List<Photo>>();
  }
  
  void work(List<Photo> photosToAnalyze){ 
    photosToAnalyze.forEach((photo){
      euclideanDistance(photo, photosToAnalyze); 
    });  
  }
  
}