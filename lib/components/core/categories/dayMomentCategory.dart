library daymomentcategory;

import 'category.dart';
import '../photo/photo.dart';
import '../photo/GroupOfPhotos/dayMomentGroupOfPhotos.dart';

class DayMomentCategory extends Category{
  
  static DayMomentCategory _instance;

  static DayMomentCategory get() {
    if (_instance == null) {
      _instance = new DayMomentCategory._();
    }
    return _instance;
  }
  
  DayMomentCategory._() : super("DAYMOMENT"){
    //TODO
  }
  
  List<DayMomentGroupOfPhotos> workDayMomentGroups(List<Photo> photos){
    var listToReturn = new List<DayMomentGroupOfPhotos>();
    
    DayMomentGroupOfPhotos nightPhotos = new DayMomentGroupOfPhotos();
    nightPhotos.setGroupName("Night");
    DayMomentGroupOfPhotos dayPhotos = new DayMomentGroupOfPhotos();
    dayPhotos.setGroupName("Day");
    
    photos.forEach((photo){
      if(!photo.isDay){
        if(nightPhotos.giveMeAllPhotos.length == 0){
          nightPhotos.setGroupFace(photo);
        }
        nightPhotos.addToList(photo);
        photo.setDayMomentGroup(nightPhotos); 
      }
      else{
        if(dayPhotos.giveMeAllPhotos.length == 0){
          dayPhotos.setGroupFace(photo);
        }
        dayPhotos.addToList(photo);
        photo.setDayMomentGroup(dayPhotos);
      }
    });
    
    listToReturn.add(nightPhotos);
    listToReturn.add(dayPhotos);
    return listToReturn;
  }
  
  void work(List<Photo> photosToAnalyze){
    photosToAnalyze.forEach((photo){
      if(photo.returnExifData.hour > 7  && photo.returnExifData.hour < 20){
        photo.setMomentOfDay(true);
      }
      else{
        photo.setMomentOfDay(false); 
      }
    });
  }
}