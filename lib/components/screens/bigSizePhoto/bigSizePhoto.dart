library bigSize;

import 'dart:html';
import 'dart:core';
import 'package:polymer/polymer.dart';
import 'package:route_hierarchical/client.dart';
import '../../core/screenModule.dart' as screenhelper;
import '../../core/photo/photo.dart';
import '../../core/database/dataBase.dart';
export "package:polymer/init.dart";

/**
 * BigSizePhoto Screen 
 */
@CustomTag(BigSizePhoto.TAG)
class BigSizePhoto extends screenhelper.SpecialScreen {
  
  static const String TAG = "big-size-photo";
  String description = "Photo big size";
  factory BigSizePhoto() => new Element.tag(TAG);
  String previousPhotoID = null;
  String mainPhotoID = null;
  Element selectedPhoto = null;
  Element previousPhoto = null;
  @observable bool isInOverflow = false;
  
  Element _summaryContainer;
  Element _standByContainer;
  Element _excludedContainer;
  Element _scrollableSummary;
  Element _scrollableStandby;
  Element _scrollableExcluded;
  
  MutationObserver observer;
  
  BigSizePhoto.created() : super.created(){
    screenTitle = "Big Size Photo";
    _summaryContainer = $['t-SUMMARY'];
    _standByContainer = $['t-STANDBY'];
    _excludedContainer = $['t-EXCLUDED'];
    _scrollableSummary = $['SUMMARY2'];
    _scrollableStandby = $['STANDBY2'];
    _scrollableExcluded = $['EXCLUDED2'];
  }

  /**
   * TODO
   */
  @override
   void setupRoutes(Route route) {
    route.addRoute(
        name: 'home',
        path: '',
        enter: (e) { 
          photo = DB.photoToDisplayPlease;
          print("Photo ID: " + photo.id);
          decideContainerToLock(photo.id);
          previousPhoto = $['photo.id'];
          print("Previous photo: " + previousPhoto.toString());
          //markDisplayingPhoto();
        });
   }
    /*
    route.addRoute(
        name: 'show',
        path: '/:id',
        enter: (e) {
          print(e.parameters['id']);
          photo = DB.find(e.parameters['id']);
          decideContainerToLock(photo.id);
          markDisplayingPhoto();
        }
    );
   }*/
    
  /*
   * TODO
   */
  @override
  void enteredView() {
    super.enteredView();
  }
  
  /*
   * TODO
   */ 
  void runStartStuff() {
    cleanAll();
    addAllCategoriesToInactive();
  }

  /*
   * TODO
   */
  home(_) {}
  
  void similarCategory(){
    photosWithSameCategory(photo);
  }

  /*
   * TODO
   */
  void returnToSummary(){
    disableSelection();
    removeCheckedAttribute();
    cleanElementSelected();
    router.go("summary-done", {});
  }

  //Arrow move Left
  void moveLeft(Event event, var detail, Element target){
    var aux;
    aux = target.parent.children[3];
    aux.scrollLeft -= 500;
  }
  
  //Arrow move Right
  void moveRight(Event event, var detail, Element target){
    var aux;
    aux = target.parent.children[3];
    aux.scrollLeft += 500;  
  }
  
  /*
   * 
   */
  void checkOverflow(){
    var element = document.querySelector('#element');
    
    if( (element.offsetHeight < element.scrollHeight) || (element.offsetWidth < element.scrollWidth)){
      isInOverflow = true;
    }
    else{
      isInOverflow = false;
    }
  }

  /*
   *
   */ 
  void markDisplayingPhoto(){
    previousPhotoID = mainPhotoID;
    mainPhotoID = photo.id;
    if(previousPhotoID != null){
      previousPhoto = $[previousPhotoID];
      previousPhoto.classes.remove('choosed');      
    }
    print("ID: " + mainPhotoID);
    selectedPhoto = $[photo.id];
    print("SELECTED PHOTO: " + selectedPhoto.toString());
    selectedPhoto.classes.add('choosed');
  }
  
  void markPhotoWithElement(Element element){
    previousPhoto = selectedPhoto;
    selectedPhoto = element;
    if(previousPhoto != null){
      previousPhoto.classes.remove('choosed');
      selectedPhoto.classes.add('choosed');
    }else{
      selectedPhoto.classes.add('choosed');
    }
  }
  
  void cleanElementSelected(){
    selectedPhoto.classes.remove('choosed');
  }
  
  void previousPhotoInList(){
    var auxiliar = 0,
        lastPhoto = null;
    auxiliar = currentContainer.photosToDisplay.indexOf(photo);
    if(auxiliar == 0){
      lastPhoto = currentContainer.photosToDisplay.last;
      photo = lastPhoto;
    }else{
      auxiliar -= 1;
      photo = currentContainer.photosToDisplay.elementAt(auxiliar);
    }
  }
  
  void nextPhotoInList(){
    var auxiliar = currentContainer.photosToDisplay.indexOf(photo),
        firstPhoto = null,
        lastPhoto = currentContainer.photosToDisplay.last;
    if(photo == lastPhoto){
      firstPhoto = currentContainer.photosToDisplay.first;
      photo = firstPhoto;   
    }else{
      auxiliar += 1;
      photo = currentContainer.photosToDisplay.elementAt(auxiliar);
    }
  }
  
  /*
   *
   */
  void showImage(Event event, var detail, Element target){
    var id = target.attributes["data-id"];
    var isSelected;
    if(!selection){
      this.photo = DB.find(target.attributes['data-id']);
      markPhotoWithElement(target);
    }
    else{
        var father = target.parent,
            firstChild = father.children.elementAt(0),
            secondChild = father.children.elementAt(1);         
        if(firstChild.classes.contains('selectedPhoto') || secondChild.classes.contains('selected') ){
          firstChild.classes.remove('selectedPhoto');
          secondChild.classes.remove('selected');
          secondChild.classes.add('notSelected');
          isSelected = "false";
          removeFromSelectedPhotos(id);
          removeFromSelectedElements(firstChild, secondChild);
          print("$id is selected? $isSelected");
        }
        else{
          secondChild.classes.remove('notSelected');
          firstChild.classes.add('selectedPhoto');
          secondChild.classes.add('selected');
          isSelected = "true";
          addToSelectedPhotos(id);
          addToSelectedElements(firstChild, secondChild);
          print("$id is selected? $isSelected");
        }
      }
  }
}