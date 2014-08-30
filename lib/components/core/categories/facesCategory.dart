library facescategory;

import 'category.dart';
import '../photo/photo.dart';
import 'dart:math';
import 'package:observe/observe.dart';
import '../photo/GroupOfPhotos/facesGroupOfPhotos.dart';


class HSI extends Object with Observable {
  
  static HSI _instance;
  double h = 0.0;
  double s = 0.0;
  double i = 0.0;

  static HSI get() {
    if (_instance == null) {
      _instance = new HSI._();
    }
    return _instance;
  }
  
  void clearVariables(){
    h = 0.0;
    s = 0.0;
    i = 0.0;
  }
  
  HSI._(){
    //TODO
  }

  HSI RGB2HSI(int R, int G, int B) {
          HSI result = get();
          result.clearVariables();
          result.i = (R+G+B)/3.0;    // we have calculated I!
          if (R==G&&G==B) {
              return result;    // return result with h=0.0 and s=0.0
          }
          double r = R/i;            // normalize R
          double g = G/i;            // normalize G
          double b = B/i;            // normalize B
          double w = 0.5*(R-G+R-B) / sqrt((R-G)*(R-G)+(R-B)*(G-B));
          if (w>1) w = 1.0;       // clip input for acos to -1 <= w <= 1
          if (w<-1) w = -1.0;     // clip input for acos to -1 <= w <= 1
          result.h = acos(w);   // the value is 0 <= h <= Math.PI
          if (B>G) {
              result.h = 2*PI - result.h;
          }
          // finally the last component s
          result.s = 1-3*min(min(r,g),b);
          
          return result;
  }
  
}

class FacesCategory extends Category{
  
  static FacesCategory _instance;

  static FacesCategory get() {
    if (_instance == null) {
      _instance = new FacesCategory._();
    }
    return _instance;
  }
  
  FacesCategory._() : super("FACES"){
    //TODO
  }
  
  bool isSkinRGB(int r, int g, int b) {
       // first easiest comparisons
       if ( (r<95) || (g<40) || (b<20) || (r<g) || (r<b) ) {
           return false; // no match, stop function here
       }
       var d = r-g;
       if ( -15<d && d<15) {
           return false; // no match, stop function here
       }
       // we have left most time consuming operation last
       // hopefully most of the time we are not reaching this point
       var maxN = max(max(r,g),b);
       var minN = min(min(r,g),b);
       if ((maxN-minN)<15) {
           // this is the worst case
           return false; // no match, stop function 
       }
       // all comparisons passed
       return true;
   }
   
   bool isSkinYCrCb(int red, int green, int blue) {
     
     //First convert from rgb to YCrCb
     var Y  = (0.257*red) + (0.504*green) + (0.098*blue) + 16;
     var Cr = (0.439*red) - (0.368*green) - (0.071*blue) + 128;
     var Cb = -(0.148*red)- (0.291*green) + (0.439*blue) + 128;
     
     if (Cr >= ((1.5862*Cb) + 20)) {
             return false;
         }
         if (Cr <= ((0.3448*Cb) + 76.2069)) {
             return false;
         }
         if (Cr <= ((-4.5652*Cb) + 234.5652)) {
             return false;
         }
         if (Cr >= ((-1.15*Cb) + 301.75)) {
             return false;
         }
         if (Cr >= ((-2.2857*Cb) + 432.85)) {
             return false;
         }
         
         // all comparisons passed
         return true;
   }
   
   bool isSkinHSI(int red, int green, int blue) {
     var HSIinstance = HSI.get();
     HSIinstance.RGB2HSI(red, green, blue);
     
     if (HSIinstance.h < 25 || HSIinstance.h > 230) {
       return true;
     }
   
     return false;
   }
   
   List<FacesGroupOfPhotos> workFacesGroups(List<Photo> photos){
    var listToReturn = new List<FacesGroupOfPhotos>();
    
    FacesGroupOfPhotos withFaces = new FacesGroupOfPhotos();
    withFaces.setGroupName("With Faces");
    FacesGroupOfPhotos withoutFaces = new FacesGroupOfPhotos();
    withoutFaces.setGroupName("Without Faces");
    photos.forEach((photo){
      if(photo.hasFaces){
        if(withFaces.giveMeAllPhotos.length == 0){
          withFaces.setGroupFace(photo);
          print("Group with Faces. Group face: " + photo.id.toString());
        }
        withFaces.addToList(photo);
        photo.setFacesGroup(withFaces); 
      }
      else{
        if(withoutFaces.giveMeAllPhotos.length == 0){
          withoutFaces.setGroupFace(photo);
          print("Group without Faces. Group face: " + photo.id.toString());
        }
        withoutFaces.addToList(photo);
        photo.setFacesGroup(withoutFaces);
      }
    });
    
    listToReturn.add(withFaces);
    listToReturn.add(withoutFaces);
    return listToReturn;
  }
  
  void work(List<Photo> photosToAnalyze){
    //Nothing to do
  }
}