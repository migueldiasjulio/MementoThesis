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
import 'thirdAuxFunctions.dart';
import '../../core/categories/facesCategory.dart' as faces;
import '../../core/categories/toningCategory.dart' as toning;
import '../../core/categories/similarCategory.dart' as similar;
import '../../core/categories/dayMomentCategory.dart' as dayMoment;

/**
 * BigSizePhoto Screen 
 */
@CustomTag(DisplayingPhoto.TAG)
class DisplayingPhoto extends screenhelper.SpecialScreen {

  final _ScreenAdvisor = ScreenAdvisor.get();
  final _ThirdAuxFunctions = ThirdAuxFunctions.get();
  static const String TAG = "displaying-photo";
  String title = "Displaying Photo",
         description = "Photo big size";
  factory DisplayingPhoto() => new Element.tag(TAG);
  Element _scrollableSummary,
          _scrollableStandby,
          _scrollableExcluded;
  MutationObserver observer;
  @observable bool needToCheckOverflow = false;

  DisplayingPhoto.created() : super.created() {
    screenTitle = "Big Size Photo";
    _scrollableSummary = $['SUMMARY2'];
    _scrollableStandby = $['STANDBY2'];
    _scrollableExcluded = $['EXCLUDED2'];
  }

  /**
   * 
   */
  @override
  void setupRoutes(Route route) {
    route.addRoute(name: 'home', path: '', enter: (e) {
      photo = DB.photoToDisplayPlease;
      decideContainerToLock(photo.id);
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
  void enteredView() => super.enteredView();

  /*
   * Run This on start
   */
  void runStartStuff() {
    _ScreenAdvisor.setScreenType(title);
    cleanAll();
    addAllCategoriesToInactive();
    summaryContainer.showPhotosWithCategories(selectedCategories, null, null);
    standbyContainer.showPhotosWithCategories(selectedCategories, null, null);
    excludedContainer.showPhotosWithCategories(selectedCategories, null, null);
    //checkOverflow();
  }
  
  void cleanAll(){
    disableSelection();
    cleanCategoriesStuff();
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
    removeCheckedAttribute();
    cleanElementSelected();
    router.go("summary-manipulation", {});
  }
 
  /*
   * 
   */
  bool checkOverflow() => toogleThNeedToCheckOverflow();
  bool toogleThNeedToCheckOverflow() => needToCheckOverflow = !needToCheckOverflow;

  
  void markPhotoWithElement(Element element) => _ThirdAuxFunctions.markPhotoWithElement(element);
  void cleanElementSelected() => _ThirdAuxFunctions.cleanElementSelected();

  void previousPhotoInList() {
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

  void nextPhotoInList() {
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

  void facesCategoryExecution() => photosWithFacesCategory(photo);
  void dayMomentCategoryExecution() => photosWithDayMomentCategory(photo);
  void toningCategoryExecution() => photosWithToningCategory(photo);
  void similarCategoryExecution() => photosWithSameCategory(photo);

  void clearAllCategoriesInDisplayMode() {
    removeFromActiveCategory(faces.FacesCategory.get());
    removeFromActiveCategory(toning.ToningCategory.get());
    removeFromActiveCategory(dayMoment.DayMomentCategory.get());
  }

  /**
   * Faces Category
   */
  void enableFacesCategory() {
    facesCategory = true;
    toningCategory = false;
    dayMomentCategory = false;
    clearAllCategoriesInDisplayMode();
  }

  void disableFacesCategory() {
    facesCategory = false;
    toningCategory = false;
    dayMomentCategory = false;
    cleanGroups();
    clearAllCategoriesInDisplayMode();
  }

  void photosWithFacesCategory(Photo photo) {
    cleanGroups();
    disableSelection();
    if (facesCategory) {
      disableFacesCategory();
    } else {
      enableFacesCategory();
      addActiveCategory(faces.FacesCategory.get());
    }
    lastGroupVisited = facesGroupOfPhotosChoosed;
    updatePhotoView(photo, facesGroupOfPhotosChoosed);
  }

  /**
   * Toning Category
   */
  void enableColorCategory() {
    facesCategory = false;
    toningCategory = true;
    dayMomentCategory = false;
    clearAllCategoriesInDisplayMode();
  }

  void disableColorCategory() {
    facesCategory = false;
    toningCategory = false;
    dayMomentCategory = false;
    cleanGroups();
    clearAllCategoriesInDisplayMode();
  }

  void photosWithToningCategory(Photo photo) {
    cleanGroups();
    disableSelection();
    if (toningCategory) {
      this.disableColorCategory();
    } else {
      this.enableColorCategory();
      addActiveCategory(toning.ToningCategory.get());
    }
    lastGroupVisited = colorGroupOfPhotosChoosed;
    updatePhotoView(photo, colorGroupOfPhotosChoosed);
  }

  /**
   * Day Moment Category
   */
  void enableDayMomentCategory() {
    facesCategory = false;
    toningCategory = false;
    dayMomentCategory = true;
    clearAllCategoriesInDisplayMode();
  }

  void disableDayMomentCategory() {
    facesCategory = false;
    toningCategory = false;
    dayMomentCategory = false;
    cleanGroups();
    clearAllCategoriesInDisplayMode();
  }

  void photosWithDayMomentCategory(Photo photo) {
    cleanGroups();
    disableSelection();
    if (dayMomentCategory) {
      disableDayMomentCategory();
    } else {
      enableDayMomentCategory();
      addActiveCategory(dayMoment.DayMomentCategory.get());
    }
    lastGroupVisited = dayMomentGroupOfPhotosChoosed;
    updatePhotoView(photo, dayMomentGroupOfPhotosChoosed);
  }

  /**
   * Same Category
   */
  void enableSameCategory() {
    facesCategory = false;
    toningCategory = false;
    dayMomentCategory = false;
    sameCategory = true;
  }

  void disableSameCategory() {
    facesCategory = false;
    toningCategory = false;
    sameCategory = false;
    dayMomentCategory = false;
    cleanGroups();
    clearSelectedCategories();
  }

  void photosWithSameCategory(Photo photo) {
    cleanGroups();
    disableSelection();
    if (sameCategory) {
      disableSameCategory();
    } else {
      enableSameCategory();
      addActiveCategory(similar.SimilarCategory.get());
    }
    lastGroupVisited = similarGroupOfPhotosChoosed;
    updatePhotoView(photo, similarGroupOfPhotosChoosed);
  }

  void getOutOfGroupInDisplayMode() {
    cleanGroups();
    updatePhotoView(photo, lastGroupVisited);
  }

  //Specific implementation for this screen
  bool allGroupsAreNull() {
    return facesGroupOfPhotosChoosed.giveMeAllPhotos.isEmpty 
        && colorGroupOfPhotosChoosed.giveMeAllPhotos.isEmpty 
        && dayMomentGroupOfPhotosChoosed.giveMeAllPhotos.isEmpty;
  }

  //Specific implementation for this screen
  bool isAnyCategoryOn() => (toningCategory == true || facesCategory == true || dayMomentCategory == true);

  /*
   *  Show image
   */
  void showImage(Event event, var detail, var target) {
    var id = target.attributes["data-id"];
    var isSelected;
    if (!selection) {
      if (isAnyCategoryOn() && allGroupsAreNull()) {
        insideGroup = true;
        Photo photo = DB.find(id);
        var correctGroup = giveMeTheRightGroupLookingToBools(true);
        correctGroup = photo.returnTheCorrectGroup(false, toningCategory, facesCategory, dayMomentCategory); //Forcing similarCategory to go false
        putItToTheRightGroup(correctGroup);
        print("Correct group: " + correctGroup.groupName.toString());
        currentContainer.showPhotosWithCategories(selectedCategories, photo, correctGroup);
      } else {
        photo = DB.find(target.attributes['data-id']);
        markPhotoWithElement(target);
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
          removeFromSelectedElements(firstChild, null);
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
    }
  }
}
