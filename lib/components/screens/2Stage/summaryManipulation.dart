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
import 'dart:js' as js show JsObject, context;
import 'summaryManipulationAuxiliar.dart';

/**
 * Summary Done Screen
 */
@CustomTag(SummaryManipulation.TAG)
class SummaryManipulation extends screenhelper.SpecialScreen {

  /**
   * Variables
   */
  final _secondAuxFunctions = SummaryManipulationAuxiliar.get();
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
    moveToContainerFunction = moveToContainer;
    
    facesCategoryExecutionFunction = facesCategoryExecution;
    dayMomentCategoryExecutionFunction = dayMomentCategoryExecution;
    toningCategoryExecutionFunction = toningCategoryExecution;
    qualityCategoryExecutionFunction = qualityCategoryExecution;
    similarCategoryExecutionFunction = similarCategoryExecution;
  }
  
  void runStartStuff() {
    _ScreenAdvisor.setScreenType(title);
    cleanAll();
    addAllCategoriesToInactive();
    summaryContainer.showPhotosWithCategories(selectedCategories, null, null, normalMode);
    standbyContainer.showPhotosWithCategories(selectedCategories, null, null, normalMode);
    excludedContainer.showPhotosWithCategories(selectedCategories, null, null, normalMode);
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
           qualityGroupOfPhotosChoosed.giveMeAllPhotos.isEmpty &&
           dayMomentGroupOfPhotosChoosed.giveMeAllPhotos.isEmpty;
  }
  
  //Specific implementation for this screen
  bool isAnyCategoryOn(){
    return sameCategory ||
        toningCategory ||
        facesCategory  ||
        qualityCategory ||
        dayMomentCategory;
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
                                                         facesCategory,  dayMomentCategory, qualityCategory);
              putItToTheRightGroup(correctGroup);
              print("Correct group: " + correctGroup.groupName.toString());
              currentContainer.showPhotosWithCategories(selectedCategories, null, correctGroup, normalMode);
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
          secondChild = target.children.last; 
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
            removeFromSelectedElements(firstChild, secondChild);
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
  void qualityCategoryExecution() => photosWithQualityCategory(null);
  void similarCategoryExecution() => photosWithSameCategory(null);
  
  
  void enablingCategories(bool faces, bool toning, bool dayMoment, bool quality, bool same){
    facesCategory = faces;
    toningCategory = toning;
    dayMomentCategory = dayMoment;
    qualityCategory = quality;
    sameCategory = same;
  }
    
  /**
   * Faces Category
   */ 
  void enableFacesCategory(){
    enablingCategories(true, false, false, false, false);
    clearSelectedCategories();
  }
  
  void disableFacesCategory(){
    cleanCategoriesStuff();
    clearSelectedCategories();
  }
  
  /**
   * Toning Category
   */ 
  void enableColorCategory(){
    enablingCategories(false, true, false, false, false);
    clearSelectedCategories();
  }
  
  void disableColorCategory(){
    cleanCategoriesStuff();
    clearSelectedCategories();
  }
  
  /**
   * Same Category
   */ 
  void enableSameCategory(){
    enablingCategories(false, false, false, false, true);
    clearSelectedCategories();
  }
  
  void disableSameCategory(){
    cleanCategoriesStuff();
    clearSelectedCategories();
  }
  
  /**
   * Day Moment Category
   */ 
  void enableDayMomentCategory(){
    enablingCategories(false, false, true, false, false);
    clearSelectedCategories();
  }
  
  void disableDayMomentCategory(){
    cleanCategoriesStuff();
    clearSelectedCategories();
  }

  /**
   * Day Moment Category
   */ 
  void enableQualityCategory(){
    enablingCategories(false, false, false, true, false);
    clearSelectedCategories();
  }
  
  void disableQualityCategory(){
    cleanCategoriesStuff();
    clearSelectedCategories();
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
    //router.go("displaying-photo", {id: id});
  }
}