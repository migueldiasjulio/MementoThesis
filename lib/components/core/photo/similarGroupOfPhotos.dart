library similargroupofphotos;

import 'photo.dart';
import 'dart:math';

class SimilarGroupOfPhotos {
  
  List<Photo> _allGroupPhotos;
  Photo _groupFace = null;
  
  SimilarGroupOfPhotos(){
    _allGroupPhotos = new List<Photo>();
  }
  
  List<Photo> get giveMeAllPhotos => _allGroupPhotos;
  Photo get groupFace => _groupFace;
  
  void setGroupFace(Photo photo){
    _groupFace = photo;
  }
  
  void chooseAnotherFace(){
    setGroupFace(chooseRandomly());
  }

  Photo chooseRandomly(){
    var photoReturn,
    random = new Random();
    var indexOfTheChoosenOne = random.nextInt(giveMeAllPhotos.length);
    while(giveMeAllPhotos.elementAt(indexOfTheChoosenOne) == _groupFace){
      indexOfTheChoosenOne = random.nextInt(giveMeAllPhotos.length);
    }
    
    photoReturn = giveMeAllPhotos.elementAt(indexOfTheChoosenOne);
    
    return photoReturn;
  }
  
  void addToList(Photo photo){
    _allGroupPhotos.add(photo);
  }
  
  void removeFromList(Photo photo){
    _allGroupPhotos.remove(photo);
  }
  
  void addAllToList(List<Photo> listOfPhotos){
    _allGroupPhotos.addAll(listOfPhotos);
  }
  
}