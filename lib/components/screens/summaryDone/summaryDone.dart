library summaryDone;

import 'dart:html';
import 'dart:core';
import 'package:polymer/polymer.dart';
import 'package:route_hierarchical/client.dart';
import '../../core/screenModule.dart' as screenhelper;
export "package:polymer/init.dart";
import '../../core/database/dataBase.dart';
import '../../core/photo/photo.dart';
import '../../core/photo/similarGroupOfPhotos.dart';


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
  
  void imNotInsideSimilarGroupAnymore(){
    insideSimilarGroup = false;
  }

  /*
   *  Show image
   */
  void showImage(Event event, var detail, var target){
    print("SHOW IMAGE");
    var id = target.attributes["data-id"];
    var isSelected;
    if(!selection){
      if(sameCategory && similarGroupOfPhotosChoosed == null){
              print("CARREGUEI E ESTOU NESTE MODO!");
              insideSimilarGroup = true;
              Photo photo = DB.find(id);
              similarGroupOfPhotosChoosed = photo.returnSimilarGroup;
              print("Similar Group Size: " + similarGroupOfPhotosChoosed.giveMeAllPhotos.length.toString());
              currentContainer.showPhotosWithCategories(selectedCategories, null, similarGroupOfPhotosChoosed);
      }else{
        print("ID: " + id.toString());
        displayPhoto(id);
      }
    }
    else{
        var father = target.parent,
            firstChild = null,
            secondChild = null;
        
        if(similarGroupOfPhotosChoosed == null && sameCategory){
          firstChild = father.children.elementAt(0);
          //secondChild = father.children.elementAt(2); 
        }else{
          firstChild = father.children.elementAt(0);
          secondChild = father.children.elementAt(1);   
        } 
        
        if(firstChild.classes.contains('selectedPhoto') /*|| secondChild.classes.contains('selected')*/ ){
          firstChild.classes.remove('selectedPhoto');
          isSelected = "false";
          removeFromSelectedPhotos(id);
          if(similarGroupOfPhotosChoosed != null || !sameCategory){
            secondChild.classes.remove('selected');
            secondChild.classes.add('notSelected');
            removeFromSelectedElements(firstChild, secondChild);
          }else{
            removeFromSelectedElements(firstChild, null);
          }
          print("$id is selected? $isSelected");
        }
        else{
          firstChild.classes.add('selectedPhoto');
          isSelected = "true";
          addToSelectedPhotos(id);
          if(similarGroupOfPhotosChoosed != null || !sameCategory){
            secondChild.classes.remove('notSelected');
            secondChild.classes.add('selected');
            addToSelectedElements(firstChild, secondChild);
          }else{
            addToSelectedElements(firstChild, null);
          }
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