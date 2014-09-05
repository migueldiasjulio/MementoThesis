library containerphotos;

import 'package:polymer/polymer.dart';
import 'dart:core';
export "package:polymer/init.dart";
import 'package:bootjack/bootjack.dart';
export 'package:route_hierarchical/client.dart';
import '../../../../core/photo/photo.dart';
import 'dart:html';
import 'package:observe/observe.dart';
import '../../auxiliarFunctions/thirdAuxFunctions.dart';
import '../../../../core/database/dataBase.dart';

final _ThirdAuxFunctions = ThirdAuxFunctions.get();

typedef void showImage(Event event, var detail, var target);

@CustomTag('last-screen-photos')
class ContainerPhotos extends PolymerElement {

  @published showImage showImageFunction;
  @published List<Photo> photosToDisplay;
  @published Container container; 
  @published Photo photo;
  @published bool insideGroup; 
  @published bool sameCategory; 
  @published bool toningCategory;
  @published bool facesCategory; 
  @published bool dayMomentCategory;  
  @published bool needToCheckOverflow;
  @published Container currentContainer;
  
  @observable bool isInOverflow = false;
  @observable bool firstTime = true;
  
  ContainerPhotos.created() : super.created(){}
  
  void showImagePlease(Event event, var detail, var target) 
  => showImageFunction(event, detail, target);
  /*
   * If the variable change we need to check if it is on overflow
   */
  void needToCheckOverflowChanged(){
    checkOverflow();
  }
  
  void markNewPhotoChanged(){
    
  }
  
  /*
   * If Photo changes, we need to mark them with a border so user can easily check what photo is selected
   */
  void photoChanged(){
    if(firstTime){markDisplayingPhoto();}
  }
  
  @override
  void enteredView(){
    super.enteredView();
    print("ESTOU A ENTRAR AQUI");
    markDisplayingPhoto();
    
  }
  
  /*
   * Mark Displaying Photo
   */
  void markDisplayingPhoto() {
    var photoID = photo.id,
        element = $[photoID];
    print("Element to mark: " + element.toString());
    //_ThirdAuxFunctions.markPhotoWithElement(element);
  }
  
  /*
   * Checking if list in on onverflow
   */
  void checkOverflow() {
    var uListName = "nav-" + container.secondname.toString(),
        element = $[uListName];

    if ((element.offsetHeight < element.scrollHeight) || (element.offsetWidth < element.scrollWidth)) {
      print("IS OVERFLOWING");
      isInOverflow = true;
    } else {
      print("NO OVERFLOW AT ALL");
      isInOverflow = false;
    }
    
    if(currentContainer == container){
      //element.classes.add('selected');
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