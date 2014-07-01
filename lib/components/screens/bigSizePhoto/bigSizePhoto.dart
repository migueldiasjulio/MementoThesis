library bigSize;

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:route_hierarchical/client.dart';
import '../../core/screenModule.dart' as screenhelper;
import '../../core/MementoImage.dart';
export "package:polymer/init.dart";

/**
 * BigSizePhoto Screen 
 */
@CustomTag(BigSizePhoto.TAG)
class BigSizePhoto extends screenhelper.SpecialScreen {

  static const String TAG = "big-size-photo";
  String title = "Big Size Photo",
         description = "Photo big size";
  factory BigSizePhoto() => new Element.tag(TAG);
  Element _name;
  @published MementoImage thumbToDisplay = null;
  MementoImage get thumbnailDisplay => thumbToDisplay;
  
  final List<MementoImage> thumbnailsToShow = toObservable([]);

  @observable bool moving = false;

  BigSizePhoto.created() : super.created();

  /**
   * TODO
   */
  @override
   void setupRoutes(Route route) {
    route.addRoute(
        name: 'home',
        path: '',
        enter: home);
   }

  /*
   * TODO
   */
  @override
  void enteredView() {
    super.enteredView();
    checkWhatPhotoToDisplay();
  }
  
  /*
   * TODO
   */ 
  void runStartStuff() {
    syncSummaryPhotos();
    syncStandByPhotos();
    syncExcludedPhotos();
    cleanVariables();
  }

  /*
   * TODO
   */
  home(_) {}

  /*
   * TODO
   */
  void checkWhatPhotoToDisplay(){
    this.thumbToDisplay = this.myDataBase.returnImageToDisplay();
  }

  /*
   * TODO
   */
  void returnToSummary(){
    router.go("summary-done", {});
  }

  /*
   *
   */
  void cancel(){
    selection=false;
    moving=false;
  }
  
  /*
   *  
   */ 
  void showImage(Event event, var detail, var target){
    var nameOfPhoto;
    var isSelected;
    if(!this.selection){
      print(target.attributes['data-incby']);
    }
    else{
      nameOfPhoto = target.attributes['data-incby'];
      isSelected = target.attributes['selected'];
      if(isSelected == "true"){
        target.attributes['selected'] = "false";
        removeFromSelectedPhotos(nameOfPhoto);
        removeFromSelectedElements(target);
        print(nameOfPhoto + " is selected? " + isSelected);
      }
      else{
        target.attributes['selected'] = "true";
        addToSelectedPhotos(nameOfPhoto);
        addToSelectedElements(target);
        print(nameOfPhoto + " is selected? " + isSelected);
      }
    }
  }
  
  void cancelMoveAction(){
    disableSelection();
    this.moving = false;
  }
  
  void enableMoveAction() {
    this.moving = true;
  }
  
  void showSummaryPhotos(){
    this.thumbnailsToShow.clear();
    this.thumbnailsToShow.addAll(this.thumbnailsSummary);
  }
  
  void showStandByPhotos(){
    this.thumbnailsToShow.clear();
    this.thumbnailsToShow.addAll(this.thumbnailsStandBy);
  }
  
  void showExcludedPhotos(){
    this.thumbnailsToShow.clear();
    this.thumbnailsToShow.addAll(this.thumbnailsExcluded);
  }
  
  void specialMoveToSummary(){
    this.moveToSummary();
    cancelMoveAction();
  }
  
  void specialMoveToStandBy(){
    this.moveToStandBy();
    cancelMoveAction();
  }
  
  void specialMoveToExcluded(){
    this.moveToExcluded();
    cancelMoveAction();
  }
  
  
}