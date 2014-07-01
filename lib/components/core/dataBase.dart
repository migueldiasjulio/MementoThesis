library database;

import 'MementoImage.dart';
import 'dart:math';
import 'mementoSettings.dart';
import 'FunctionChoosed.dart' as Function;
import 'dart:html';

class Database {

  MementoSettings _settings = MementoSettings.get();
  
  List<String> _newNameToAddToMap;
  Map<String, MementoImage> _helpSearching = new Map<String, MementoImage>();
 
  List<String> _summaryContainer = new List<String>();
  List<String> _standByContainer = new List<String>();
  List<String> _excludedContainer = new List<String>();

  //Aux
  Map<String, MementoImage> _map = null;
  List<String> _namesToAdd = new List<String>();
  List<MementoImage> _newDataBaseElementsToAdd = new List <MementoImage>();
  MementoImage _newDataBaseElement = null;
  
  /**
   * Singleton
   */
  static Database _instance;

  Database._();

  static Database get() {
    if (_instance == null) {
      _instance = new Database._();
    }
    return _instance;
  }

  /**
   * User for BigSizePhoto - Change this maybe?
   */
  String ImageToBeDisplayed = "";
  
  /**
   * Return image to be displayed in BigSizePhoto Screen
   * @return Thumbnail
   */ 
  MementoImage returnImageToDisplay(){
    return this._helpSearching[this.ImageToBeDisplayed];
  }

  /**
   * Set the image to be displayed
   * @param thumbName - String
   */ 
  void setImageToBeDisplayed(String thumbName){
    this.ImageToBeDisplayed = thumbName;
  }

  /**
   * Add a new element to the database
   */
  void addNewElementsToDataBase(List<String> filesSrc, List<MementoImage> newMementoImages){
    var fileListSize = newMementoImages.length;
    for(var i = 0; i < fileListSize; i++){
      if(!alreadyExistsInTheDataBase(newMementoImages.elementAt(i).imageTitle)){
        this._namesToAdd.add(newMementoImages.elementAt(i).imageTitle);
        this._newDataBaseElement = newMementoImages.elementAt(i);
        this._newDataBaseElementsToAdd.add(this._newDataBaseElement);
      }
    }

    testFunctionOne(); //TODO

    this.updateMap(this._namesToAdd, this._newDataBaseElementsToAdd);

    //Adding all photos to stand-by container
    this.addToContainer("STANDBY", this._namesToAdd);

    //Cleaning
    this._namesToAdd.clear();
    this._newDataBaseElementsToAdd.clear();
    this._newDataBaseElement = null;

    testFunctionTwo(); //TODO
}

  /**
   * Update Map
   */
  void updateMap(List<String> newNames, List<MementoImage> newDataBaseElements){
    this._map = new Map.fromIterables(newNames, newDataBaseElements);
    this._helpSearching.addAll(_map);
    this._map = null;
  }

  /**
   * Check if already exists in the database
   */
  bool alreadyExistsInTheDataBase(String file){
    return this._helpSearching.containsKey(file);
  }

  /**
   * Add to container
   */
  void addToContainer(String _nameOfContainer, List<String> _imagesToAdd){

    switch(_nameOfContainer){
      case("SUMMARY") :
        this._summaryContainer.addAll(_imagesToAdd);
        break;
      case("STANDBY") :
        this._standByContainer.addAll(_imagesToAdd);
        break;
      case("EXCLUDED") :
        this._excludedContainer.addAll(_imagesToAdd);
        break;
      default: break;
    }
    this.printContainersState(); //TODO
  }

  /**
   * Add to container
   */
  void moveFromTo(String _origin, String _destination , List<String> _imagesToMove){

    switch(_origin){
      case("SUMMARY") :
        switch(_destination) {
          case("STANDBY") :
            this._standByContainer.addAll(_imagesToMove);
            for(String photosToRemove in _imagesToMove){
              this._summaryContainer.remove(photosToRemove);
            }
            break;
          case("EXCLUDED") :
            this._excludedContainer.addAll(_imagesToMove);
          for(String photosToRemove in _imagesToMove){
            this._summaryContainer.remove(photosToRemove);
          }
            break;
        }
        break;
      case("STANDBY") :
        switch(_destination) {
          case("SUMMARY") :
            this._summaryContainer.addAll(_imagesToMove);
            for(String photosToRemove in _imagesToMove){
              this._standByContainer.remove(photosToRemove);
            }
            break;
          case("EXCLUDED") :
            this._excludedContainer.addAll(_imagesToMove);
            for(String photosToRemove in _imagesToMove){
              this._standByContainer.remove(photosToRemove);
            }
            break;
        }
        break;
      case("EXCLUDED") :
        switch(_destination) {
          case("SUMMARY") :
            this._summaryContainer.addAll(_imagesToMove);
            for(String photosToRemove in _imagesToMove){
              this._excludedContainer.remove(photosToRemove);
            }
            break;
          case("STANDBY") :
            this._standByContainer.addAll(_imagesToMove);
            for(String photosToRemove in _imagesToMove){
              this._excludedContainer.remove(photosToRemove);
            }
            break;
        }
        break;
      default: break;
    }
    this.printContainersState(); //TODO
  }
  
  /**
   * Decide which algorithm to use in the summary creation
   */ 
  void decideAlgorithm(int numberOfPhotos){
    var function = _settings.whichAlgorithmInUse();
    switch(function){
      case(Function.FunctionChoosed.FIRSTX) :
        workFirstXSummary(numberOfPhotos);  
        break; 
      case(Function.FunctionChoosed.RANDOM) :
        buildRandomSummary(numberOfPhotos);
        break; 
      case(Function.FunctionChoosed.HIERARCHICAL) :
        buildClusterSummary(numberOfPhotos);
        break;
      default: 
        break; 
    }   
  }

  /**
   * First X photos
   */
  void workFirstXSummary(int numberOfPhotos){
    var number = numberOfPhotos;
    print(number.toString());
    for(int i = 0; i < number; i++){
      print("Number i is now: " + i.toString());
      this._summaryContainer.add(this._standByContainer.elementAt(0));
      this._standByContainer.removeAt(0);
    }
    this.printContainersState(); //TODO
  }

  /**
   * For random tests
   */
  void buildRandomSummary(int numberOfPhotos){
    var randomStuff = new Random();
    var next;
    for(int i = 0; i < numberOfPhotos; i++){
      next = randomStuff.nextInt(this._standByContainer.length);
      this._summaryContainer.add(this._standByContainer.elementAt(next));
      this._standByContainer.removeAt(i);
    }
    this.printContainersState(); //TODO
  }

  /**
   * With cluster algorithm
   */
  void buildClusterSummary(int numberOfPhotos){
    
    
    ///start algorithm
    
    
    
    
    
    
    
    
    
    
    this.printContainersState(); //TODO
  }

  List<MementoImage> getThumbnails(String fromWhere){
    List<MementoImage> list = new List<MementoImage>();
    MementoImage thumb;
    List<String> container;

    switch(fromWhere){
      case("SUMMARY") :
        container = this._summaryContainer;
        for(String photo in container){
            list.add(this._helpSearching[photo]);
        }
        //return list;
        break; 
      case("STANDBY") :
        container = this._standByContainer;
        for(String photo in container){
            list.add(this._helpSearching[photo]);
        }
        //return list;
        break; 
      case("EXCLUDED") :
        container = this._excludedContainer;
        for(String photo in container){
            list.add(this._helpSearching[photo]);
        }
        //return list;
        break;
      default: 
        list = null;
        break; 
    }
    
    return list;
 }
  
  /**
   *  
   * TEST FUNCTIONS
   * 
   */

  /**
   * 
   */ 
  void printContainersState(){
    print("<<<<<<<<<< Containers >>>>>>>>>>");
    var sizeOf;
    print("-> Summary Container <-");
    sizeOf = this._summaryContainer.length;
    print("Summary container size: " + this._summaryContainer.length.toString());
    for(var i = 0; i < sizeOf; i++){
      print("Element: " + this._summaryContainer.elementAt(i));
    }
    print("-> Summary Container <-");
    print("-> Stand by Container <-");
    sizeOf = this._standByContainer.length;
    print("Stand-by container size: " + this._standByContainer.length.toString());
    for(var i = 0; i < sizeOf; i++){
      print("Element: " + this._standByContainer.elementAt(i));
    }
    print("-> Stand by Container <-");
    print("-> Excluded Container <-");
    sizeOf = this._excludedContainer.length;
    print("Excluded container size: " + this._excludedContainer.length.toString());
    for(var i = 0; i < sizeOf; i++){
      print("Element: " + this._excludedContainer.elementAt(i));
    }
    print("-> Excluded Container <-");
    print("<<<<<<<<<< Containers >>>>>>>>>>");
  }
  
  /**
   * 
   */ 
  void testFunctionOne(){
    print("---------- Before update --------");
    print("Names To add size: " + this._namesToAdd.length.toString());
    print("New Elements to Add size: " + this._newDataBaseElementsToAdd.length.toString());
    print("New element is null? " + this._newDataBaseElement.toString());
    print("---------- Before update --------");
  }

  /**
   * 
   */
  void testFunctionTwo(){
    print("---------- After update --------");
    print("Map size: " + this._helpSearching.length.toString());
    print("Names To add size: " + this._namesToAdd.length.toString());
    print("New Elements to Add size: " + this._newDataBaseElementsToAdd.length.toString());
    print("New element is null? " + this._newDataBaseElement.toString());
    this.printContainersState();
    print("---------- After update --------");
  }

}//dataBase