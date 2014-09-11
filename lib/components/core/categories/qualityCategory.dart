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
  
  List<QualityGroupOfPhotos> workQualityGroups(List<Photo> photos){
   var listToReturn = new List<QualityGroupOfPhotos>();
    
   QualityGroupOfPhotos goodQuality = new QualityGroupOfPhotos();
   goodQuality.setGroupName("Good Quality");
   
   QualityGroupOfPhotos mediumQuality = new QualityGroupOfPhotos();
   mediumQuality.setGroupName("Medium Quality");
   
   QualityGroupOfPhotos badQuality = new QualityGroupOfPhotos();
   badQuality.setGroupName("Bad Quality");
   

   photos.forEach((photo){
     if(photo.histogramDiff <= 0.25){
       if(goodQuality.giveMeAllPhotos.length == 0){
         goodQuality.setGroupFace(photo);
       }
       goodQuality.addToList(photo);
       photo.setQualityGroup(goodQuality); 
     }
     else{
       if(photo.histogramDiff > 0.25 && photo.histogramDiff <= 0.70){
         if(mediumQuality.giveMeAllPhotos.length == 0){
           mediumQuality.setGroupFace(photo);
         }
         mediumQuality.addToList(photo);
         photo.setQualityGroup(mediumQuality);
       }
       else{
         if(badQuality.giveMeAllPhotos.length == 0){
           badQuality.setGroupFace(photo);
         }
         badQuality.addToList(photo);
         photo.setQualityGroup(badQuality);
       }
      }
   });
   listToReturn.add(goodQuality);
   listToReturn.add(mediumQuality);
   listToReturn.add(badQuality);
   
   return listToReturn; 
  }
  
  void work(List<Photo> photosToAnalyze){
    //Nothing to do
  }
}