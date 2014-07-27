library screenModule;

import 'package:polymer/polymer.dart';
import 'package:route_hierarchical/client.dart';
export 'package:route_hierarchical/client.dart';
import 'database/dataBase.dart';
import 'settings/mementoSettings.dart';
import 'categories/category.dart';
import 'categories/facesCategory.dart' as faces;
import 'categories/blackAndWhiteCategory.dart' as bw;
import 'categories/colorCategory.dart' as color;
import 'categories/similarCategory.dart' as similar;
import 'dart:html';
import 'dart:core';
import 'photo/photo.dart';
import 'package:bootjack/bootjack.dart';

/**
 * Screen Module
 */
abstract class ScreenModule extends PolymerElement {
  
  String title, description, path;
  Router router;
  MementoSettings settings = MementoSettings.get();
  
  // This lets the CSS "bleed through" into the Shadow DOM of this element.
  bool get applyAuthorStyles => true;
  bool get preventDispose => true;
  
  ScreenModule.created() : super.created();
  
  /*
   * Run This on start on which screen
   */
  void runStartStuff() {} 
  
  /*
   * Store the root router and return the mountFn
   */
  mount(String path, Router router) {
    this.path = path;
    this.router = router;
    return setupRoutes;
  }

  /*
   * Setup routes is @overrrided in which screen
   */
  void setupRoutes(Route route);

  /*
   * Navigate between screens
   */
  navigate(event, detail, target) {
     router.go("${target.dataset["target"]}", {});
  }

  /*
   * Go Home
   */
  goHome() {
    router.go("home", {});
  }

  /*
   * Go Root
   */
  goRoot() {
    router.go(path, {});
  }
  
  /*
   * 
   */ 
  void sortPhotos(){
    //TODO need to complete this
  }
}

/**
 * Screen abstract class
 * Used for all screen, but not for summaryDone e BigSizePhoto
 */
abstract class Screen extends ScreenModule {

  Screen.created() : super.created();
}

/**
 * Used by SummaryDone screen and BigSizePhoto Screen
 */ 
abstract class SpecialScreen extends ScreenModule {
  
  @observable bool selection = false;
  
  @observable Container currentContainer;
  
  @observable Container summaryContainer = DB.container(SUMMARY);
  @observable Container standbyContainer = DB.container(STANDBY);
  @observable Container excludedContainer = DB.container(EXCLUDED);
  @observable get containers => DB.containers.values;
  
  final List<String> selectedPhotos = toObservable([]);
  final List<Element> selectedElements = toObservable([]);
  final List<Category> _selectedCategories =  toObservable([]);
  
  @observable bool allCategories = true;
  @observable bool facesCategory = true;
  @observable bool BWCategory = true;
  @observable bool ColorCategory = true;
  @observable bool sameCategory = true;  
  
  Element _summaryContainer;
  Element _standByContainer;
  Element _excludedContainer;
  
  Modal exportMenu;
  
  String screenTitle = "";
  
  SpecialScreen.created() : super.created() {
    initializeCategories();
    Modal.use();
    exportMenu = Modal.wire($['exportMenu']);
    
    _summaryContainer = $['t-SUMMARY'];
    _standByContainer = $['t-STANDBY'];
    _excludedContainer = $['t-EXCLUDED'];
  }
  
  void decideContainerToLock(String photoId){
    var photoContainer = DB.findContainer(photoId);
    print("Container name to check: " + photoContainer.containerName);
    switch(photoContainer.containerName){
      case("SUMMARY"): 
        checkSummaryContainer();
        break;
      case("STANDBY"): 
        checkStandByContainer();
        break;
      case("EXCLUDED"): 
        checkExcludedContainer();
        break;
    }
  }
  
  void printContainerAttributes(){
    print("SUMMARY CONTAINER ATTRIBUTES: " + _summaryContainer.attributes.keys.toString());
    print("STANDBY CONTAINER ATTRIBUTES: " + _standByContainer.attributes.keys.toString());
    print("EXCLUDED CONTAINER ATTRIBUTES: " + _excludedContainer.attributes.keys.toString());
  }
  
  void removeCheckedAttribute(){
    _summaryContainer.attributes.remove('checked');
    _standByContainer.attributes.remove('checked');
    _excludedContainer.attributes.remove('checked'); 
  }
  
  void checkSummaryContainer(){
    _summaryContainer.setAttribute("checked", "checked");
    printContainerAttributes();
    currentContainer = summaryContainer;
  }
  
  void checkStandByContainer(){
    _standByContainer.setAttribute("checked", "checked");
    printContainerAttributes();
    currentContainer = standbyContainer;
  }
  
  void checkExcludedContainer(){
    _excludedContainer.setAttribute("checked", "checked");
    printContainerAttributes();
    currentContainer = excludedContainer;
  }
  
  void initializeCategories(){  
    _selectedCategories.add(faces.FacesCategory.get());
    _selectedCategories.add(bw.BlackAndWhiteCategory.get());
    _selectedCategories.add(color.ColorCategory.get());
    _selectedCategories.add(similar.SimilarCategory.get());
  }
  
  /**
   * Selection Functions
   */ 
  
  /*
   * Enable Selection
   */
  void enableSelection(){
    this.selection = true;
  }

  /*
   * Disable Selection
   */
  void disableSelection(){
    this.selection = false;
    cleanSelection();
  }
  
  void cleanAll(){
    this.disableSelection();
  }
  
  /*
   * Add to selected Photos List
   */
  void addToSelectedPhotos(String photoName){
    this.selectedPhotos.add(photoName);
  }

  /*
   * Remove from selected Photos List
   */
  void removeFromSelectedPhotos(String photoName){
    this.selectedPhotos.remove(photoName);
  }

  /*
   * Add to selected Elements list 
   */ 
  void addToSelectedElements(Element element){
    this.selectedElements.add(element);
  }

  /*
   * Remove from selected Elements list
   */ 
  void removeFromSelectedElements(Element element){
    this.selectedElements.remove(element);
  }

  /*
   *  Return All Selected Elements
   */ 
  List<Element> returnAllSelectedElements(){
    return this.selectedElements;
  }
  
  /**
   * Selection Functions
   */ 
  
  /**
   *  Move Functions
   */ 
  
  /*
   * Move to container
   */
  void moveToContainer(event, detail, target){
    var container = DB.container(target.attributes['container']);
    var photos = selectedPhotos.map((id) => currentContainer.find(id));
    DB.moveFromTo(currentContainer.name, container.name, photos);
    disableSelection();
  }
  
  /**
   *  Move Functions
   */

  /**
   * Location Functions
   */

  void selectContainer(event, detail, target) {
    currentContainer = DB.container(target.dataset["container"]);
    cleanSelection();
  }
  

  /*
   * Clean selected objects _ Used when the user cancel the selection operation
   */
  void cleanSelection(){
    for(Element element in this.selectedElements){
      element.classes.remove('selected');
    }
    this.selectedElements.clear();
    this.selectedPhotos.clear();
  }
  
  /**
   * Categories Functions
   * 
   */ 
  
  void updatePhotoView(Photo photo){
    summaryContainer.showPhotosWithCategories(_selectedCategories, photo);
    standbyContainer.showPhotosWithCategories(_selectedCategories, photo);
    excludedContainer.showPhotosWithCategories(_selectedCategories, photo);
  }

  void addActiveCategory(Category category){
    _selectedCategories.add(category);
  }
  
  void removeFromActiveCategory(Category category){
    _selectedCategories.remove(category);
  }
  
  void clearSelectedCategories(){
    _selectedCategories.clear();
  }
  
  /**
   * All Categories
   */ 
  void enableAllCategories(){
    this.allCategories = true;
    this.facesCategory = true;
    this.BWCategory = true;
    this.ColorCategory = true;
    this.sameCategory = true;
  }
  
  void disableAllCategories(){
    this.allCategories = false;
    this.facesCategory = false;
    this.BWCategory = false;
    this.ColorCategory = false;
    this.sameCategory = false;
  }
    
  void addAllCategoriesToActive(){
    addActiveCategory(faces.FacesCategory.get());
    addActiveCategory(bw.BlackAndWhiteCategory.get());
    addActiveCategory(color.ColorCategory.get());
    addActiveCategory(similar.SimilarCategory.get()); 
  }
  
  void allPhotosCategory(){
    cleanSelection();
    if(this.allCategories){
      this.disableAllCategories();
      clearSelectedCategories();
    }else{
      this.enableAllCategories();
      clearSelectedCategories();
      addAllCategoriesToActive();
    }
    updatePhotoView(null);
  }
  
  /**
   * Faces Category
   */ 
  
  void enableFacesCategory(){
    this.facesCategory = true;
  }
  
  void disableFacesCategory(){
    this.facesCategory = false;
    this.allCategories = false;
  }
  
  void photosWithFacesCategory(){
    cleanSelection();
    if(this.facesCategory){
      this.disableFacesCategory();
      removeFromActiveCategory(faces.FacesCategory.get());
    }else{
      this.enableFacesCategory();
      addActiveCategory(faces.FacesCategory.get());
    }
    print("Displaying Photos with faces");
    updatePhotoView(null);
  }
  
  /**
   * Black and White Category
   */ 
  void enableBWCategory(){
    this.BWCategory = true;
  }
  
  void disableBWCategory(){
    this.BWCategory = false;
    this.allCategories = false;
  }
  
  void photosWithBWCategory(){
    cleanSelection();
    if(this.BWCategory){
      this.disableBWCategory();
      removeFromActiveCategory(bw.BlackAndWhiteCategory.get());
    }else{
      this.enableBWCategory();
      addActiveCategory(bw.BlackAndWhiteCategory.get());
    }
    print("Displaying Black and White Photos");
    updatePhotoView(null);
  }
  
  /**
   * Color Category
   */ 
  void enableColorCategory(){
    this.ColorCategory = true;
  }
  
  void disableColorCategory(){
    this.ColorCategory = false;
    this.allCategories = false;
  }
  
  void photosWithColorCategory(){
    cleanSelection();
    if(this.ColorCategory){
      this.disableColorCategory();
      removeFromActiveCategory(color.ColorCategory.get());
    }else{
      this.enableColorCategory();
      addActiveCategory(color.ColorCategory.get());
    }
    print("Displaying Color Photos");
    updatePhotoView(null);
  }
  
  /**
   * Same Category
   */ 
  void enableSameCategory(){
    this.sameCategory = true;
  }
  
  void disableSameCategory(){
    this.sameCategory = false;
    this.allCategories = false;
  }
  
  void photosWithSameCategory(Photo photo){
    cleanSelection();
    if(this.sameCategory){
      this.disableSameCategory();
      removeFromActiveCategory(similar.SimilarCategory.get());
    }else{
      this.enableSameCategory();
      addActiveCategory(similar.SimilarCategory.get());
    }
    print("Displaying equivalent Photos");
    updatePhotoView(photo);
  }
  
  void exportSummary(){
    this.exportMenu.show();
    exportToHardDrive();
  }

  void exportToFacebook(){}
  
  void exportToHardDrive(){
    List<String> names = new List<String>();
    
    this.summaryContainer.photos.forEach((photo){
      names.add(photo.title + "\n");
    });
    
    List test = new List();
    test.addAll(names);

    Blob blob = new Blob(test, 'text/plain', 'native');
    String url = Url.createObjectUrlFromBlob(blob);
    AnchorElement link = new AnchorElement()
        ..href = url
        ..download = 'Memento.txt'
        ..text = 'My Device';

    // Insert the link into the DOM.
    var myDevice = $['myDeviceDownload'];
    myDevice.append(link);
  }
  
}