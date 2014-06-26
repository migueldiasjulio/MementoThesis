library screenModule;

import 'package:polymer/polymer.dart';
import 'package:route_hierarchical/client.dart';
export 'package:route_hierarchical/client.dart';
import 'dataBase.dart';
import 'mementoSettings.dart';
import 'photo.dart';
import 'dart:html';
import 'dart:core';

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

  final List<String> selectedPhotos = toObservable([]);

  final List<Element> selectedElements = toObservable([]);

  SpecialScreen.created() : super.created() {
    currentContainer = summaryContainer;
  }

  @observable get containers => DB.containers.values;

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

  /*
   * Add to selected Photos List
   */
  void addToSelectedPhotos(String photoName){
    selectedPhotos.add(photoName);
  }

  /*
   * Remove from selected Photos List
   */
  void removeFromSelectedPhotos(String photoName){
    selectedPhotos.remove(photoName);
  }

  /*
   * Add to selected Elements list
   */
  void addToSelectedElements(Element element){
    selectedElements.add(element);
  }

  /*
   * Remove from selected Elements list
   */
  void removeFromSelectedElements(Element element){
    selectedElements.remove(element);
  }

  /*
   *  Return All Selected Elements
   */
  List<Element> returnAllSelectedElements(){
    return selectedElements;
  }

  /**
   * Selection Functions
   */

  /**
   *  Move Functions
   */

  /**
   * Move to container
   */
  void moveToContainer(event, detail, target){
    var container = DB.container(target.dataset["container"]);
    print("");
    print("MOVING TO ${container.name} CONTAINER");
    var photos = selectedPhotos.map((id) => container.find(id));
    DB.moveFromTo(currentContainer.name, container.name, photos);
    cleanAll();
  }


  /**
   *  Move Functions
   */

  /**
   * Location Functions
   */

  void selectContainer(event, detail, target) {
    currentContainer = DB.container(target.dataset["container"]);
  }

  /**
   * Sync Functions
   */

  /**
   * Clean Functions
   */

  /*
   * Clean All
   */
  void cleanAll(){
    cleanSelectedElements();
    cleanSelection();
  }

  /*
   * Clean selected elements
   */
  void cleanSelectedElements(){
    this.selectedElements.clear();
  }

  /*
   * Clean Variables
   */
  void cleanVariables(){
    this.selectedPhotos.clear();
  }

  /*
   * Clean selected objects _ Used when the user cancel the selection operation
   */
  void cleanSelection(){
    for(Element element in this.selectedElements){
      element.attributes['selected'] = "false";
    }
    this.selectedElements.clear();
    this.selectedPhotos.clear();
  }

  /**
   * Test functions
   */
}