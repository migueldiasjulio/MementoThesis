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
  Element selectedPhoto;
  Element previousPhoto;

  @observable Photo photo;
  
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
          print("Photo src: " + photo.thumbnail.src);
          print("Photo title: " + photo.thumbnail.title.toString());
          removeCheckedAttribute();
          decideContainerToLock(photo.id);
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
  
  /*
   *
   */
  void showImage(Event event, var detail, Element target){
    var id = target.attributes["data-id"];
    var isSelected;
    if(!selection){
      print(target.attributes['data-incby']);
      this.photo = DB.find(target.attributes['data-id']);
      markDisplayingPhoto();
    } 
    else{
      if(sameCategory){
        Photo photo = DB.find(id);
        similarGroupOfPhotosChoosed = photo.returnSimilarGroup;
        currentContainer.showPhotosWithCategories(selectedCategories, null, similarGroupOfPhotosChoosed);
      }else{
        if(target.classes.contains('selected')){
          target.classes.remove('selected');
          isSelected = "false";
          removeFromSelectedPhotos(id);
          removeFromSelectedElements(target);
          print("$id is selected? $isSelected");
        } 
        else{
          target.classes.add('selected');
          isSelected = "true";
          addToSelectedPhotos(id);
          addToSelectedElements(target);
          print("$id is selected? $isSelected");
        }
      }
    }
  }  
}