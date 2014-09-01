library summaryManipulation;

import 'dart:html';
import 'dart:core';
import 'package:polymer/polymer.dart';
import 'package:route_hierarchical/client.dart';
import '../defaultScreen/screenModule.dart' as screenhelper;
export "package:polymer/init.dart";
import '../../core/database/dataBase.dart';
import '../../core/photo/photo.dart';
import '../screenAdvisor.dart';
import '../../core/categories/facesCategory.dart' as faces;
import '../../core/categories/toningCategory.dart' as toning;
import '../../core/categories/similarCategory.dart' as similar;
import '../../core/categories/dayMomentCategory.dart' as dayMoment;
import 'dart:js' as js show JsObject, context;

/**
 * Summary Done Screen
 */
@CustomTag(SummaryManipulation.TAG)
class SummaryManipulation extends screenhelper.SpecialScreen {

  /**
   * Variables
   */
  final _ScreenAdvisor = ScreenAdvisor.get();
  static const String TAG = "summary-manipulation";
  String  title = "Summary Manipulation",
          description = "Summary results";
  factory SummaryManipulation() => new Element.tag(TAG);
  bool firstTime = true;
  
  /**
   * Building Summary Done
   */
  SummaryManipulation.created() : super.created(){
    screenTitle = "Summary Manipulation";
  }
  
  void runStartStuff() {
    _ScreenAdvisor.setScreenType(title);
    cleanAll();
    addAllCategoriesToInactive();
    summaryContainer.showPhotosWithCategories(selectedCategories, null, null);
    standbyContainer.showPhotosWithCategories(selectedCategories, null, null);
    excludedContainer.showPhotosWithCategories(selectedCategories, null, null);
  }
  
  //Specific implementation for this screen
  void cleanAll(){
    disableSelection();
    cleanCategoriesStuff();
  }
  
  bool checkOverflow(){
    //I dont need this here
    return false;
  }
  
  /**
   * On enter view
   */
  @override
  void enteredView() {
    super.enteredView();
    cleanAll();
  }
  
  //Specific implementation for this screen
  bool allGroupsAreNull(){
    return similarGroupOfPhotosChoosed.giveMeAllPhotos.isEmpty &&
           facesGroupOfPhotosChoosed.giveMeAllPhotos.isEmpty &&
           colorGroupOfPhotosChoosed.giveMeAllPhotos.isEmpty &&
           dayMomentGroupOfPhotosChoosed.giveMeAllPhotos.isEmpty;
  }
  
  //Specific implementation for this screen
  bool isAnyCategoryOn(){
    return sameCategory == true ||
        toningCategory == true ||
        facesCategory == true ||
        dayMomentCategory == true;
  }

  /*
   *  Show image
   */
  void showImage(Event event, var detail, var target){
    var id = target.attributes["data-id"];
    var isSelected;
    if(!selection){
      if(isAnyCategoryOn() && allGroupsAreNull()){
              insideGroup = true;
              Photo photo = DB.find(id);
              var correctGroup = giveMeTheRightGroupLookingToBools(false);
              correctGroup = photo.returnTheCorrectGroup(sameCategory, toningCategory, 
                                                         facesCategory,  dayMomentCategory);
              putItToTheRightGroup(correctGroup);
              print("Correct group: " + correctGroup.groupName.toString());
              currentContainer.showPhotosWithCategories(selectedCategories, null, correctGroup);
      }else{
        displayPhoto(id);
      }
    }
    else{
        var father = target.parent,
            firstChild = null,
            secondChild = null;
        
        if(allGroupsAreNull() && isAnyCategoryOn()){
          firstChild = target.children.elementAt(0);
          secondChild = target.children.elementAt(2); 
        }else{
          firstChild = father.children.elementAt(0);
          secondChild = father.children.elementAt(1);   
        } 
        
        if(firstChild.classes.contains('selectedPhoto')){
          firstChild.classes.remove('selectedPhoto');
          isSelected = "false";
          removeFromSelectedPhotos(id);
          if(!allGroupsAreNull() || !isAnyCategoryOn()){
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
          if(!allGroupsAreNull() || !isAnyCategoryOn()){
            secondChild.classes.remove('notSelected');
            secondChild.classes.add('selected');
            addToSelectedElements(firstChild, secondChild);
          }else{
            addToSelectedElements(firstChild, secondChild);
          }
          print("$id is selected? $isSelected");
        }
      }
    }
    
  void facesCategoryExecution() => photosWithFacesCategory(null);
  void dayMomentCategoryExecution() => photosWithDayMomentCategory(null);
  void toningCategoryExecution() => photosWithToningCategory(null);
  void similarCategoryExecution() => photosWithSameCategory(null);
  
  /**
   * Faces Category
   */ 
  void enableFacesCategory(){
    facesCategory = true;
    toningCategory = false;
    sameCategory = false;
    dayMomentCategory = false;
    clearSelectedCategories();
  }
  
  void disableFacesCategory(){
    facesCategory = false;
    toningCategory = false;
    sameCategory = false;
    dayMomentCategory = false;
    cleanGroups();
    clearSelectedCategories();
  }
  
  void photosWithFacesCategory(Photo photo){
    cleanGroups();
    disableSelection();
    if(facesCategory){
      disableFacesCategory();
      //removeFromActiveCategory(faces.FacesCategory.get());
    }else{
      enableFacesCategory();
      addActiveCategory(faces.FacesCategory.get());
    }
    lastGroupVisited = facesGroupOfPhotosChoosed;
    updatePhotoView(photo, facesGroupOfPhotosChoosed);
  }
  
  /**
   * Toning Category
   */ 
  void enableColorCategory(){
    facesCategory = false;
    toningCategory = true;
    sameCategory = false;
    dayMomentCategory = false;
    clearSelectedCategories();
  }
  
  void disableColorCategory(){
    facesCategory = false;
    toningCategory = false;
    sameCategory = false;
    dayMomentCategory = false;
    cleanGroups();
    clearSelectedCategories();
  }
  
  void photosWithToningCategory(Photo photo){
    cleanGroups();
    disableSelection();
    if(toningCategory){
      this.disableColorCategory();
    }else{
      this.enableColorCategory();
      addActiveCategory(toning.ToningCategory.get());
    }
    lastGroupVisited = colorGroupOfPhotosChoosed;
    updatePhotoView(photo, colorGroupOfPhotosChoosed);
  }
  
  /**
   * Same Category
   */ 
  void enableSameCategory(){
    facesCategory = false;
    toningCategory = false;
    sameCategory = true;
    dayMomentCategory = false;
    clearSelectedCategories();
  }
  
  void disableSameCategory(){
    facesCategory = false;
    toningCategory = false;
    sameCategory = false;
    dayMomentCategory = false;
    cleanGroups();
    clearSelectedCategories();
  }
  
  void photosWithSameCategory(Photo photo){
    cleanGroups();
    disableSelection();
    if(sameCategory){
      disableSameCategory();
    }else{
      enableSameCategory();
      addActiveCategory(similar.SimilarCategory.get());
    }
    lastGroupVisited = similarGroupOfPhotosChoosed;
    updatePhotoView(photo, similarGroupOfPhotosChoosed);
  }
  
  /**
   * Same Category
   */ 
  void enableDayMomentCategory(){
    facesCategory = false;
    toningCategory = false;
    sameCategory = false;
    dayMomentCategory = true;
    clearSelectedCategories();
  }
  
  void disableDayMomentCategory(){
    facesCategory = false;
    toningCategory = false;
    sameCategory = false;
    dayMomentCategory = false;
    cleanGroups();
    clearSelectedCategories();
  }
  
  void photosWithDayMomentCategory(Photo photo){
    cleanGroups();
    disableSelection();
    if(dayMomentCategory){
      disableDayMomentCategory();
    }else{
      enableDayMomentCategory();
      addActiveCategory(dayMoment.DayMomentCategory.get());
    }
    lastGroupVisited = dayMomentGroupOfPhotosChoosed;
    updatePhotoView(photo, dayMomentGroupOfPhotosChoosed);
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
    router.go("displaying-photo", {});
    //router.go("big-size-photo.show", {id: id});
  }
}