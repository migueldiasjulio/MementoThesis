library photorepresentation;

import 'photo.dart';

class PhotoRepresentation {
  Photo headerPhoto = null;
  List<Photo> almostTheSamePhoto = null;
  
  PhotoRepresentation(Photo photo, bool groupOfPhotos){
    headerPhoto = photo;
    if(groupOfPhotos){
      almostTheSamePhoto = photo.almostTheSamePhoto;
    }
  }

}