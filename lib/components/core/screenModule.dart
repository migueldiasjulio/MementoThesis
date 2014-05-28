library screenModule;

import 'package:polymer/polymer.dart';
import 'package:route_hierarchical/client.dart';
export 'package:route_hierarchical/client.dart';
import 'dataBase.dart';
import 'mementoSettings.dart';
import 'Thumbnail.dart';
import 'dart:html';
import 'dart:core';

/**
 * Screen Module
 */
abstract class ScreenModule extends PolymerElement {
  
  String title, description, path;
  Router router;
  MementoSettings settings = MementoSettings.get();
  Database myDataBase = Database.get();
  
  // This lets the CSS "bleed through" into the Shadow DOM of this element.
  bool get applyAuthorStyles => true;
  bool get preventDispose => true;
  
  ScreenModule.created() : super.created();
  
  /**
   * Run This on start on which screen
   */
  void runStartStuff() {} 
  
  /**
   * Store the root router and return the mountFn
   */
  mount(String path, Router router) {
    this.path = path;
    this.router = router;
    return setupRoutes;
  }

  /**
   * Setup routes is @overrrided in which screen
   */
  void setupRoutes(Route route);

  /**
   * Navigate between screens
   */
  navigate(event, detail, target) {
     router.go("${target.dataset["target"]}", {});
  }

  /**
   * Go Home
   */
  goHome() {
    router.go("home", {});
  }

  /**
   * Go Root
   */
  goRoot() {
    router.go(path, {});
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
  @observable bool atSummary = true;
  @observable bool atStandBy = false;
  @observable bool atExcluded = false;

  final List<Thumbnail> thumbnailsSummary = toObservable([]);
  final List<Thumbnail> thumbnailsStandBy = toObservable([]);
  final List<Thumbnail> thumbnailsExcluded = toObservable([]);
  final List<String> selectedPhotos = toObservable([]);
  final List<Element> selectedElements = toObservable([]);
  
  SpecialScreen.created() : super.created();
  
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
  
  /**
   * Move to Summary container
   */
  void moveToSummary(){
    print("");
    print("MOVING TO SUMMARY CONTAINER");
    if(atStandBy){
      movePhotosFunction("STANDBY", "SUMMARY");
      cleanAll();
      return;
    }
    if(atExcluded){
      movePhotosFunction("EXCLUDED", "SUMMARY");
      cleanAll();     
      return;
    }
  }

  /**
   * Move to Stand-by container
   */
  void moveToStandBy(){
    print("");
    print("MOVING TO STANDBY CONTAINER");
    if(atSummary){
      movePhotosFunction("SUMMARY", "STANDBY");
      cleanAll();
      return;
    }
    if(atExcluded){
      movePhotosFunction("EXCLUDED", "STANDBY");
      cleanAll();     
      return;
    }
  }

  /**
   * Move to excluded container
   */
  void moveToExcluded(){
    print("");
    print("MOVING TO EXCLUDED CONTAINER");
    if(atSummary){
      movePhotosFunction("SUMMARY", "EXCLUDED");
      cleanAll();
      return;
    }
    if(atStandBy){
      movePhotosFunction("STANDBY", "EXCLUDED");
      cleanAll();     
      return;
    }
  }

  /*
   * Move function front end
   * @param origin - String
   * @param destination - String 
   */
  void movePhotosFunction(String origin, String destination){
    List<Thumbnail> thumbsToMove = new List<Thumbnail>();
    for(String photoToMove in this.selectedPhotos){
      thumbsToMove.add(returnThumbnail(origin, photoToMove));
    }
    print("Ja tenho os thumbs para mover. Tamanho: " + thumbsToMove.length.toString());
    moveFromTo(origin, destination, thumbsToMove);
  }

  /*
   * Function created to help the moving action of a photo from a "from" container
   * to a "to" container.
   * @param from - String
   * @param to - String
   * @param thumbnails - List<Thumbnail>
   */
  void moveFromTo(String from, String to, List<Thumbnail> thumbnails){
    switch(from){
         case("SUMMARY") :
           switch(to) {
             case("STANDBY") :
               moveFunction(from, to, thumbnails, this.thumbnailsSummary, this.thumbnailsStandBy);
               break;
             case("EXCLUDED") :
               moveFunction(from, to, thumbnails, this.thumbnailsSummary, this.thumbnailsExcluded);
               break;
           }
           break;
         case("STANDBY") :
           switch(to) {
             case("SUMMARY") :
               moveFunction(from, to, thumbnails, this.thumbnailsStandBy, this.thumbnailsSummary);
               break;
             case("EXCLUDED") :
               moveFunction(from, to, thumbnails, this.thumbnailsStandBy, this.thumbnailsExcluded);
               break;
           }
           break;
         case("EXCLUDED") :
           switch(to) {
             case("SUMMARY") :
               moveFunction(from, to, thumbnails, this.thumbnailsExcluded, this.thumbnailsSummary);
               break;
             case("STANDBY") :
               moveFunction(from, to, thumbnails, this.thumbnailsExcluded, this.thumbnailsStandBy);
               break;
           }
           break;
         default: break;
       }
  }

  /*
   * When we already know the photo/photos new destination we change them localy to the page
   * and we inform the database about that changes
   * @param from
   * @param to
   * @param thumbs
   * @param origin
   * @param destination
   */
  void moveFunction(String from, String to,
      List<Thumbnail> thumbs, List<Thumbnail> origin, List<Thumbnail> destination){

    List<String> thumbNames = new List<String>();
    for(Thumbnail thumb in thumbs){
      origin.remove(thumb);
      destination.add(thumb);
      thumbNames.add(thumb.title);
      printContainersSize();
    }
    this.myDataBase.moveFromTo(from, to, thumbNames);
  }
 
  /*
   * Return thumbnail with name as argument
   * We receive the origin container so we can know from where we gonna get the thumbnail
   * @param photoName - String
   * @return Thumbnail
   */
  Thumbnail returnThumbnail(String origin, String photoName){
    Thumbnail thumbReturn = null;
    switch(origin){
         case("SUMMARY") :            //NOOOOB change this later (for loop to search for thumbnail; change for Map)
               for(Thumbnail thumb in this.thumbnailsSummary){
                 if(thumb.title == photoName){
                   thumbReturn = thumb;
                   break;
                 }
               }
               break;
         case("STANDBY") :
           for(Thumbnail thumb in this.thumbnailsStandBy){
             if(thumb.title == photoName){
               thumbReturn = thumb;
               break;
             }
           }
           break;
         case("EXCLUDED") :
           for(Thumbnail thumb in this.thumbnailsExcluded){
             if(thumb.title == photoName){
               thumbReturn = thumb;
               break;
             }
           }
           break;
         default: break;
       }
    return thumbReturn;
  }
  
  /**
   *  Move Functions
   */
  
  /**
   * Location Functions
   */
  
  /*
   * Inform that im in Summary container
   */ 
  void imInSummary(){
    print("");
    print("Im at Summary container");
    setMyPosition("SUMMARY", true);
    setMyPosition("STANDBY", false);
    setMyPosition("EXCLUDED", false);
    
    printVariableStante(); //TODO Just test function
  }
  
  /*
   * Inform that im in Standby container
   */ 
  void imInStandBy(){
    print("");
    print("Im at Stand by container");
    setMyPosition("STANDBY", true);
    setMyPosition("SUMMARY", false);
    setMyPosition("EXCLUDED", false);
    
    printVariableStante(); //TODO Just test function
  }
  
  /*
   * Inform that im in Excluded container
   */ 
  void imInExcluded(){
    print("");
    print("Im at Excluded container");
    setMyPosition("EXCLUDED", true);
    setMyPosition("SUMMARY", false);
    setMyPosition("STANDBY", false);
    
    printVariableStante(); //TODO Just test function
  }
  
  /*
   * Set my specific location
   */ 
  void setMyPosition(String container, bool signal){
    switch(container){
         case("SUMMARY") :            
            this.atSummary = signal;
            break;
         case("STANDBY") :
           this.atStandBy = signal;
           break;
         case("EXCLUDED") :
           this.atExcluded = signal;
           break;
         default: break;
       } 
  }
  
  /**
   * Location Functions
   */ 
  
  /**
   * Sync Functions
   */ 
  
  /*
   * Sync Summary Photos List
   */ 
  void syncSummaryPhotos(){
    thumbnailsSummary.clear();
    thumbnailsSummary.addAll(this.myDataBase.getThumbnails("SUMMARY"));
  }

  /*
   * Sync Stand-by Photos List
   */ 
  void syncStandByPhotos(){
    thumbnailsStandBy.clear();
    thumbnailsStandBy.addAll(this.myDataBase.getThumbnails("STANDBY"));
  }

  /*
   * Sync Excluded Photos List
   */ 
  void syncExcludedPhotos(){
    thumbnailsExcluded.clear();
    thumbnailsExcluded.addAll(this.myDataBase.getThumbnails("EXCLUDED"));
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
   * Clean Functions
   */
   
  /**
   * Test functions
   */ 
  void printContainersSize(){
    print("§§§§§§§§§§§§§§§§§");
    print("Summary container: " + this.thumbnailsSummary.length.toString());
    print("Stand-by container: " + this.thumbnailsStandBy.length.toString());
    print("Excluded container: " + this.thumbnailsExcluded.length.toString());
    print("§§§§§§§§§§§§§§§§§");
  }

  void printVariableStante(){
    print("§§§§§§§§§§§§§§§§§");
    print("Summary container is active? " + this.atSummary.toString());
    print("Stand by container is active? " + this.atStandBy.toString());
    print("Excluded container is active? " + this.atExcluded.toString());
    print("§§§§§§§§§§§§§§§§§");
  }
  
  /**
   * Test functions
   */ 
}