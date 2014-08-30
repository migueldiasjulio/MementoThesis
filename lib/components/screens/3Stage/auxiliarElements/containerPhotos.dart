library containerphotos;

import 'package:polymer/polymer.dart';
import 'dart:core';
export "package:polymer/init.dart";
import 'package:bootjack/bootjack.dart';
export 'package:route_hierarchical/client.dart';
import '../../../core/photo/photo.dart';
import 'dart:html';
import 'package:observe/observe.dart';
import '../thirdAuxFunctions.dart';
import '../../../core/database/dataBase.dart';

final _ThirdAuxFunctions = ThirdAuxFunctions.get();

@CustomTag('last-screen-photos')
class ContainerPhotos extends PolymerElement {

  @published Photo photo;
  @published List<Photo> photosToDisplay;
  @published Container container; 
  @published bool insideGroup; 
  @published bool sameCategory; 
  @published bool toningCategory;
  @published bool facesCategory; 
  @published bool dayMomentCategory;  
  @published bool needToCheckOverflow;
  @observable bool isInOverflow = _ThirdAuxFunctions.isOverflowing;
  
  ContainerPhotos.created() : super.created(){}
  
  /*
   * If the variable change we need to check if it is on overflow
   */
  void needToCheckOverflowChanged(){
    checkOverflow();
  }
  
  /*
   * If Photo changes, we need to mark them with a border so user can easily check what photo is selected
   */
  void photoChanged(){
    markDisplayingPhoto();
  }
  
  /*
   * Mark Displaying Photo
   */
  void markDisplayingPhoto() {
    var photoID = photo.id,
        element = $[photoID];
    _ThirdAuxFunctions.markPhotoWithElement(element);
  }
  
  /*
   * Checking if list in on onverflow
   */
  void checkOverflow() {
    var uListName = "nav-" + container.secondname.toString(),
        element = $[uListName];

    if ((element.offsetHeight < element.scrollHeight) || (element.offsetWidth < element.scrollWidth)) {
      _ThirdAuxFunctions.setIfItIsInOverflow(true);
    } else {
      _ThirdAuxFunctions.setIfItIsInOverflow(false);
    }
  }
  
  /*
   * Functions so we can move to the left in overflow mode of the u list. ul depends on the current container.
   */
  void moveLeft(Event event, var detail, Element target) {
    var uListName = "nav-" + container.secondname.toString(),
        element = $[uListName];
    element.scrollLeft -= 500;
  }

  /*
   * Functions so we can move to the right in overflow mode of the u list. ul depends on the current container
   */
  void moveRight(Event event, var detail, Element target) {
    var uListName = "nav-" + container.secondname.toString(),
        element = $[uListName];
    element.scrollLeft += 500;
  }
  
}