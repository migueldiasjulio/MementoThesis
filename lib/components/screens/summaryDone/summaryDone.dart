library summaryDone;

import 'dart:html';
import 'dart:core';
import 'package:polymer/polymer.dart';
import 'package:route_hierarchical/client.dart';
import '../../core/screenModule.dart' as screenhelper;
export "package:polymer/init.dart";
import '../../core/database/dataBase.dart';

/**
 * Summary Done Screen
 */
@CustomTag(SummaryDone.TAG)
class SummaryDone extends screenhelper.SpecialScreen {

  /**
   * Variables
   */
  static const String TAG = "summary-done";
  String description = "Summary results";
  factory SummaryDone() => new Element.tag(TAG);
  bool firstTime = true;
  
  /**
   * Building Summary Done
   */
  SummaryDone.created() : super.created(){
    screenTitle = "Summary Done";
  }

  void runStartStuff() {
    cleanAll();
    addAllCategoriesToInactive();
  }
  
  /**
   * On enter view
   */
  @override
  void enteredView() {
    super.enteredView();
    cleanAll();
  }

  /*
   *  Show image
   */
  void showImage(Event event, var detail, var target){
    var id = target.attributes["data-id"];
    var isSelected;
    if(!selection){
      print("ID: " + id.toString());
      displayPhoto(id);
    }
    else{
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
  
  void similarCategory(){
    photosWithSameCategory(null);
  }

  /*
   * Setup Routes
   */
  @override
   void setupRoutes(Route route) {
    route.addRoute(
        name: 'home',
        path: '',
        enter: (e) { 
          if(firstTime){
          checkSummaryContainer();
          firstTime = false;
          }
        });
   }

  /*
   * Home
   */
  home(_) {}

  /*
   * Go Big Size Photo Screen
   */
  void displayPhoto(String id){
    DB.setPhotoToDisplay(id);
    router.go("big-size-photo", {});
    //router.go("big-size-photo.show", {id: id});
  }
}