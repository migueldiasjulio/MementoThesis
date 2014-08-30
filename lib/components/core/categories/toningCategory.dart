library toningcategory;

import 'category.dart';
import '../photo/photo.dart';
import '../photo/GroupOfPhotos/colorGroupOfPhotos.dart';

class ToningCategory extends Category{
  
  static ToningCategory _instance;

  static ToningCategory get() {
    if (_instance == null) {
      _instance = new ToningCategory._();
    }
    return _instance;
  }
  
  ToningCategory._() : super("TONING"){
    //TODO
  }
  
  List<ColorGroupOfPhotos> workToningGroups(List<Photo> photos){
   var listToReturn = new List<ColorGroupOfPhotos>();
    
   ColorGroupOfPhotos colorPhotos = new ColorGroupOfPhotos();
   colorPhotos.setGroupName("Color");
   ColorGroupOfPhotos blackAndWhitePhotos = new ColorGroupOfPhotos();
   blackAndWhitePhotos.setGroupName("Black and White");
   photos.forEach((photo){
     if(!photo.isColor){
       if(blackAndWhitePhotos.giveMeAllPhotos.length == 0){
         blackAndWhitePhotos.setGroupFace(photo);
       }
       blackAndWhitePhotos.addToList(photo);
       photo.setColorGroup(blackAndWhitePhotos); 
     }
     else{
       if(colorPhotos.giveMeAllPhotos.length == 0){
         colorPhotos.setGroupFace(photo);
       }
       colorPhotos.addToList(photo);
       photo.setColorGroup(colorPhotos);
     }
   });
   
   listToReturn.add(colorPhotos);
   listToReturn.add(blackAndWhitePhotos);
   return listToReturn; 
  }
  
  void work(List<Photo> photosToAnalyze){
    //Nothing to do
  }
}