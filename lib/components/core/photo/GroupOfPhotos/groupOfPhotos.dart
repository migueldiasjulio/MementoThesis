library groupofphotos;

import '../photo.dart';
import 'dart:math';

class GroupOfPhotos implements Comparable<GroupOfPhotos> {

  /*
   * 
   */
  List<Photo> _allGroupPhotos = null;
  Photo _groupFace = null;
  String _name = "";

  /*
   * 
   */
  GroupOfPhotos() {
    _allGroupPhotos = new List<Photo>();
  }

  /*
   * 
   */
  List<Photo> get giveMeAllPhotos => _allGroupPhotos;
  Photo get groupFace => _groupFace;
  String get groupName => _name;

  /*
   * 
   */
  void clear() {
    _allGroupPhotos.clear();
    _groupFace = null;
  }

  /*
   * 
   */
  void setGroupFace(Photo photo) {
    _groupFace = photo;
  }

  /*
   * 
   */
  void chooseAnotherFace() {
    setGroupFace(chooseRandomly());
  }

  /*
   * 
   */
  void setGroupName(String name) {
    _name = name;
  }

  /*
   * 
   */
  Photo chooseRandomly() {
    var photoReturn,
        random = new Random();
    var indexOfTheChoosenOne = random.nextInt(giveMeAllPhotos.length);
    while (giveMeAllPhotos.elementAt(indexOfTheChoosenOne) == _groupFace) {
      indexOfTheChoosenOne = random.nextInt(giveMeAllPhotos.length);
    }
    photoReturn = giveMeAllPhotos.elementAt(indexOfTheChoosenOne);

    return photoReturn;
  }

  /*
   * 
   */
  void addToList(Photo photo) {
    _allGroupPhotos.add(photo);
  }

  /*
   * 
   */
  void removeFromList(Photo photo) {
    _allGroupPhotos.remove(photo);
  }

  /*
   * 
   */
  void addAllToList(List<Photo> listOfPhotos) {
    _allGroupPhotos.addAll(listOfPhotos);
  }

  /*
   * 
   */
  int compareTo(GroupOfPhotos o) {
    var result;
    if (o == null || o.giveMeAllPhotos.length == 0) {
      result = -1;
    } else if (o.giveMeAllPhotos.length == 0) {
      result = 1;
    } else {
      result = (this.giveMeAllPhotos.length).compareTo(o.giveMeAllPhotos.length);
    }

    return result;
  }

}
