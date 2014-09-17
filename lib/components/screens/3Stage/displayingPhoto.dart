library displayingPhoto;

import 'dart:html';
import 'dart:core';
import 'package:polymer/polymer.dart';
import 'package:route_hierarchical/client.dart';
import '../defaultScreen/screenModule.dart' as screenhelper;
import '../../core/photo/photo.dart';
import '../../core/database/dataBase.dart';
export "package:polymer/init.dart";
import '../screenAdvisor.dart';
import 'auxiliarFunctions/thirdAuxFunctions.dart';
import '../../core/categories/facesCategory.dart' as faces;
import '../../core/categories/toningCategory.dart' as toning;
import '../../core/categories/similarCategory.dart' as similar;
import '../../core/categories/dayMomentCategory.dart' as dayMoment;
import '../../core/categories/qualityCategory.dart' as quality;

/**
 * BigSizePhoto Screen 
 */
@CustomTag(DisplayingPhoto.TAG)
class DisplayingPhoto extends screenhelper.SpecialScreen {

  /*
   * 
   */
  final _ScreenAdvisor = ScreenAdvisor.get();
  final _ThirdAuxFunctions = ThirdAuxFunctions.get();
  static const String TAG = "displaying-photo";
  String title = "Displaying Photo",
      description = "Photo big size";
  factory DisplayingPhoto() => new Element.tag(TAG);
  Element _scrollableSummary, _scrollableStandby, _scrollableExcluded, _goLeft;
  MutationObserver observer;
  int countLeft = 0;
  int countRight = 0;
  @observable var showImageFunction;
  @observable bool markNewPhoto = false;
  @observable Photo similarRelatedToThisOne = null;
  @observable var changeSimilarPhotoFunction;
  bool damnHackFirstTime = true;
  Element lockedContainer = null;
  /*
   * 
   */
  DisplayingPhoto.created() : super.created() {
    screenTitle = "Big Size Photo";
    _scrollableSummary = $['SUMMARY2'];
    _scrollableStandby = $['STANDBY2'];
    _scrollableExcluded = $['EXCLUDED2'];
    _goLeft = $['goLeft'];
    print(_goLeft.toString());
    
    moveToContainerFunction = moveToContainer;
    facesCategoryExecutionFunction = facesCategoryExecution;
    dayMomentCategoryExecutionFunction = dayMomentCategoryExecution;
    toningCategoryExecutionFunction = toningCategoryExecution;
    similarCategoryExecutionFunction = similarCategoryExecution;
    qualityCategoryExecutionFunction = qualityCategoryExecution;
    changeSimilarPhotoFunction = changeSimilarPhoto;
    showImageFunction = showImage;
    
    window.onKeyDown.listen((KeyboardEvent e) {
      if(e.keyCode.toString() == "37"){previousPhotoInList();}
      if(e.keyCode.toString() == "39"){nextPhotoInList(); }
    });
  }
  
  

  void similarRelatedToThisOneChanged(){
    var group = similarRelatedToThisOne.returnTheCorrectGroup(false, toningCategory, facesCategory, 
            dayMomentCategory, qualityCategory); //Forcing similarCategory to go false
        updatePhotoView(similarRelatedToThisOne, group);
  }
  
  bool toogleMarkNewPhoto() => markNewPhoto = !markNewPhoto;
  
  /**
   * 
   */
  @override
  void setupRoutes(Route route) {
    route.addRoute(name: 'home', path: '', enter: (e) {
      photo = DB.photoToDisplayPlease;
      similarRelatedToThisOne = photo;
      decideContainerToLock(photo.id);
      toogleMarkNewPhoto();
      checkOverflow();
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
   * Entering View
   */
  @override
  void enteredView(){
    super.enteredView();
  }
  /*
   * Run This on start
   */
  void runStartStuff() {
    removeCheckedAttribute();
    _ScreenAdvisor.setScreenType(title);
    cleanAll();
    addAllCategoriesToInactive();
    summaryContainer.showPhotosWithCategories(selectedCategories, null, null, normalMode);
    standbyContainer.showPhotosWithCategories(selectedCategories, null, null, normalMode);
    excludedContainer.showPhotosWithCategories(selectedCategories, null, null, normalMode);
    normalMode = true;    
  }

  void cleanAll() {
    disableSelection();
    cleanCategoriesStuff();
  }
  
  void changeSimilarPhoto(){
    similarRelatedToThisOne = photo;
  }

  /*
   * TODO
   */
  home(_) {}

  void similarCategory() => photosWithSameCategory(photo);

  /*
   * TODO
   */
  void returnToSummary() {
    disableSelection();
    cleanElementSelected();
    removeCheckedAttribute();
    router.go("summary-manipulation", {});
  }

  /*
   * 
   */
  bool checkOverflow() => toogleThNeedToCheckOverflow();
    
  /*
   * 
   */
  void cleanElementSelected() => _ThirdAuxFunctions.cleanElementSelected();
  
  /*
   * 
   */
  void previousPhotoInList() { 
    if(!insideGroup && (facesCategory || toningCategory || dayMomentCategory || qualityCategory)){
      //Nothing
    }else{
      var auxiliar = 0,
          lastPhoto = null;
      auxiliar = currentContainer.photosToDisplay.indexOf(photo);
      if (auxiliar == 0) {
        lastPhoto = currentContainer.photosToDisplay.last;
        photo = lastPhoto;
      } else {
        auxiliar -= 1;
        photo = currentContainer.photosToDisplay.elementAt(auxiliar);
      }
    }
  }

  /*
   * 
   */
  void nextPhotoInList() {
    if(!insideGroup && (facesCategory || toningCategory || dayMomentCategory || qualityCategory)){
      //Nothing
    }else{
      var auxiliar = currentContainer.photosToDisplay.indexOf(photo),
          firstPhoto = null,
          lastPhoto = currentContainer.photosToDisplay.last;
      if (photo == lastPhoto) {
        firstPhoto = currentContainer.photosToDisplay.first;
        photo = firstPhoto;
      } else {
        auxiliar += 1;
        photo = currentContainer.photosToDisplay.elementAt(auxiliar);
      }
    }
  }

  /*
   * 
   */
  void facesCategoryExecution(){
   
    photosWithFacesCategory(similarRelatedToThisOne);
  }
  
  void dayMomentCategoryExecution(){
    photosWithDayMomentCategory(similarRelatedToThisOne);
  }
  
  void toningCategoryExecution(){
    photosWithToningCategory(similarRelatedToThisOne);
  }
  
  void similarCategoryExecution(){
    photosWithSameCategory(similarRelatedToThisOne);
  }
  
  void qualityCategoryExecution(){
    photosWithQualityCategory(similarRelatedToThisOne);
  }

  /*
   * 
   */
  void clearAllCategoriesInDisplayMode() {
    removeFromActiveCategory(faces.FacesCategory.get());
    removeFromActiveCategory(toning.ToningCategory.get());
    removeFromActiveCategory(dayMoment.DayMomentCategory.get());
    removeFromActiveCategory(quality.QualityCategory.get());
    if(normalMode){removeFromActiveCategory(similar.SimilarCategory.get());}
  }
  
  void enablingCategories(bool faces, bool toning, bool dayMoment, bool quality){
    facesCategory = faces;
    toningCategory = toning;
    dayMomentCategory = dayMoment;
    qualityCategory = quality;
    if(normalMode){ sameCategory = false;}
  }
  
  void disablingCategories(){
    facesCategory = false;
    toningCategory = false;
    dayMomentCategory = false;
    qualityCategory = false;
    if(normalMode){sameCategory = false;}
  }

  /**
   * Faces Category
   */
  void enableFacesCategory() {
    enablingCategories(true, false, false, false);
    if(normalMode){
      clearSelectedCategories();
    }else{
      clearAllCategoriesInDisplayMode(); 
    }
    toogleMarkNewPhoto();
  }

  /*
   * 
   */
  void disableFacesCategory() {
    disablingCategories();
    cleanGroups();
    clearAllCategoriesInDisplayMode();
    toogleMarkNewPhoto();
  }

  /**
   * Toning Category
   */
  void enableColorCategory() {
    enablingCategories(false, true, false, false);
    if(normalMode){
      clearSelectedCategories();
    }else{
      clearAllCategoriesInDisplayMode(); 
    }
    toogleMarkNewPhoto();
  }

  /*
   * 
   */
  void disableColorCategory() {
    disablingCategories();
    cleanGroups();
    clearAllCategoriesInDisplayMode();
    toogleMarkNewPhoto();
  }

  /**
   * Day Moment Category
   */
  void enableDayMomentCategory() {
    enablingCategories(false, false, true, false);
    if(normalMode){
      clearSelectedCategories();
    }else{
      clearAllCategoriesInDisplayMode(); 
    }
    toogleMarkNewPhoto();
  }

  /*
   * 
   */
  void disableDayMomentCategory() {
    disablingCategories();
    cleanGroups();
    clearAllCategoriesInDisplayMode();
    toogleMarkNewPhoto();
  }
  
  /*
   * Quality Category
   */
  void enableQualityCategory(){
    enablingCategories(false, false, false, true);
    if(normalMode){
      clearSelectedCategories();
    }else{
      clearAllCategoriesInDisplayMode(); 
    }
    toogleMarkNewPhoto();
  }
  
  void disableQualityCategory(){
    disablingCategories();
    cleanGroups();
    clearAllCategoriesInDisplayMode();
    toogleMarkNewPhoto();
  }

  /**
   * Same Category
   */
  void enableSameCategory() {
    facesCategory = false;
    toningCategory = false;
    dayMomentCategory = false;
    sameCategory = true;
    normalMode = false;
    toogleMarkNewPhoto();
  }

  /*
   * 
   */
  void disableSameCategory() {
    disablingCategories();
    sameCategory = false;
    normalMode = true;
    cleanGroups();
    clearSelectedCategories();
    toogleMarkNewPhoto();
  }

  /*
   * 
   */
  void getOutOfGroupInDisplayMode() {
    cleanGroups();
    updatePhotoView(photo, lastGroupVisited);
  }

  /*
   * 
   */
  //Specific implementation for this screen
  bool allGroupsAreNull() {
    return facesGroupOfPhotosChoosed.giveMeAllPhotos.isEmpty 
        && colorGroupOfPhotosChoosed.giveMeAllPhotos.isEmpty
        && qualityGroupOfPhotosChoosed.giveMeAllPhotos.isEmpty
        && dayMomentGroupOfPhotosChoosed.giveMeAllPhotos.isEmpty;
  }

  /*
   * 
   */
  //Specific implementation for this screen
  bool isAnyCategoryOn() => (toningCategory || facesCategory || dayMomentCategory || qualityCategory);

  /*
   *  Show image
   */
  void showImage(Event event, var detail, var target) {
    var id = target.attributes["data-id"],
        isSelected;
    if (!selection) {
      if (isAnyCategoryOn() && allGroupsAreNull()) {
        insideGroup = true;
        Photo photo = DB.find(id);
        var correctGroup = giveMeTheRightGroupLookingToBools(true);
        correctGroup = photo.returnTheCorrectGroup(false, toningCategory, facesCategory, 
            dayMomentCategory, qualityCategory); //Forcing similarCategory to go false
        putItToTheRightGroup(correctGroup);
        print("Correct group: " + correctGroup.groupName.toString());
        currentContainer.showPhotosWithCategories(selectedCategories, photo, correctGroup, normalMode);
        toogleMarkNewPhoto();
      } else {
        print("Simplesmente click");
        photo = DB.find(target.attributes['data-id']);
        toogleMarkNewPhoto();
      }
    } else {
      var father = target.parent,
          firstChild = null,
          secondChild = null;

      if (allGroupsAreNull() && isAnyCategoryOn()) {
        firstChild = target.children.elementAt(0);
        secondChild = target.children.elementAt(2);
      } else {
        firstChild = father.children.elementAt(0);
        secondChild = father.children.elementAt(1);
      }

      if (firstChild.classes.contains('selectedPhoto')) {
        firstChild.classes.remove('selectedPhoto');
        isSelected = "false";
        removeFromSelectedPhotos(id);
        if (!allGroupsAreNull() || !isAnyCategoryOn()) {
          secondChild.classes.remove('selected');
          secondChild.classes.add('notSelected');
          removeFromSelectedElements(firstChild, secondChild);
        } else {
          removeFromSelectedElements(firstChild, secondChild);
        }
        print("$id is selected? $isSelected");
      } else {
        firstChild.classes.add('selectedPhoto');
        isSelected = "true";
        addToSelectedPhotos(id);
        if (!allGroupsAreNull() || !isAnyCategoryOn()) {
          secondChild.classes.remove('notSelected');
          secondChild.classes.add('selected');
          addToSelectedElements(firstChild, secondChild);
        } else {
          addToSelectedElements(firstChild, secondChild);
        }
        print("$id is selected? $isSelected");
      }
      toogleMarkNewPhoto();
    }
  }
}
