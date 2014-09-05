library qualitycategory;

import 'category.dart';
import '../photo/photo.dart';
import '../photo/GroupOfPhotos/qualityGroupOfPhotos.dart';

class QualityCategory extends Category{
  
  static QualityCategory _instance;

  static QualityCategory get() {
    if (_instance == null) {
      _instance = new QualityCategory._();
    }
    return _instance;
  }
  
  QualityCategory._() : super("QUALITY"){
    //TODO
  }
  
  List<QualityGroupOfPhotos> workToningGroups(List<Photo> photos){
   var listToReturn = new List<QualityGroupOfPhotos>();
    
   QualityGroupOfPhotos goodQuality = new QualityGroupOfPhotos();
   goodQuality.setGroupName("Good Quality");
   
   QualityGroupOfPhotos mediumQuality = new QualityGroupOfPhotos();
   mediumQuality.setGroupName("Medium Quality");
   
   QualityGroupOfPhotos badQuality = new QualityGroupOfPhotos();
   badQuality.setGroupName("Bad Quality");
   
   /*
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
   */
  }
  
  void work(List<Photo> photosToAnalyze){
    //Nothing to do
  }
}