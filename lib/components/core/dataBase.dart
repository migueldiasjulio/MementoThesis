library database;

import 'PhotoType.dart';
import 'Thumbnail.dart';

class Database {

  ///CHANGE THIS
  String photoName = null;

  String get givephotoName => this.photoName;

  void set setPhotoName(String photoName) {
    this.photoName = photoName;
  }
  /// CHANGE THIS

  List<String> newNameToAddToMap;
  Map<String, photoType> helpSearching = new Map<String, photoType>();
  
  List<String> summaryContainer = new List<String>();
  List<String> standByContainer = new List<String>();
  List<String> excludedContainer = new List<String>();
  
  //Aux
  Map<String, photoType> map = null;
  List<String> namesToAdd = new List<String>();
  List<photoType> newDataBaseElementsToAdd = new List <photoType>();
  photoType newDataBaseElement = null;
  int version = 1;

  int returnVersion(){
    return version;
  }

  void incVersion(){ ///should be private
    version++;
  }

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
   * Add a new element to the database
   */
  void addNewElementsToDataBase(List<String> originalFiles, List<Thumbnail> thumbnailFiles){
    var fileListSize = thumbnailFiles.length;
    for(var i = 0; i < fileListSize; i++){
      if(!alreadyExistsInTheDataBase(thumbnailFiles.elementAt(i).title)){
        this.namesToAdd.add(thumbnailFiles.elementAt(i).title);
        this.newDataBaseElement = new photoType(originalFiles.elementAt(i), thumbnailFiles.elementAt(i));
        this.newDataBaseElementsToAdd.add(this.newDataBaseElement);
      }
  }//ciclo for

  incVersion();

  print("---------- Before update --------");
  print("Names To add size: " + this.namesToAdd.length.toString());
  print("New Elements to Add size: " + this.newDataBaseElementsToAdd.length.toString());
  print("New element is null? " + this.newDataBaseElement.toString());
  print("---------- Before update --------");

    this.updateMap(this.namesToAdd, this.newDataBaseElementsToAdd);

    //Adding all photos to stand-by container 
    this.addToContainer("STANDBY", this.namesToAdd);

    //Cleaning
    this.namesToAdd.clear();
    this.newDataBaseElementsToAdd.clear();
    this.newDataBaseElement = null;

    //Testing
    print("---------- After update --------");
    //print("Data Base elements size: " + this.dataBaseImage.length.toString());
    print("Map size: " + this.helpSearching.length.toString());

    print("Names To add size: " + this.namesToAdd.length.toString());
    print("New Elements to Add size: " + this.newDataBaseElementsToAdd.length.toString());
    print("New element is null? " + this.newDataBaseElement.toString());

    this.printContainersState();

    print("---------- After update --------");
    //Testing
}//addNewElementsToDataBase

  /**
   * Update Map
   */
  void updateMap(List<String> newNames, List<photoType> newDataBaseElements){
    this.map = new Map.fromIterables(newNames, newDataBaseElements);
    this.helpSearching.addAll(map);
    this.map = null;
  }

  /**
   * Check if already exists in the database
   */
  bool alreadyExistsInTheDataBase(String file){
    return this.helpSearching.containsKey(file);
  }

  /**
   * Add to container
   */
  void addToContainer(String _nameOfContainer, List<String> _imagesToAdd){

    switch(_nameOfContainer){
      case("SUMMARY") :
        this.summaryContainer.addAll(_imagesToAdd);
        break;
      case("STANDBY") :
        this.standByContainer.addAll(_imagesToAdd);
        break;
      case("EXCLUDED") :
        this.excludedContainer.addAll(_imagesToAdd);
        break;
      default: break;
    }
    this.printContainersState(); 
  }

  /**
   * Add to container
   */
  void moveFromTo(String _origin, String _destination , List<String> _imagesToMove){

    switch(_origin){
      case("SUMMARY") :
        switch(_destination) {
          case("STANDBY") :
            this.standByContainer.addAll(_imagesToMove);
            break;
          case("EXCLUDED") :
            this.excludedContainer.addAll(_imagesToMove);
            break;
        }
        break;
      case("STANDBY") :
        switch(_destination) {
          case("SUMMARY") :
            this.summaryContainer.addAll(_imagesToMove);
            break;
          case("EXCLUDED") :
            this.excludedContainer.addAll(_imagesToMove);
            break;
        }
        break;
      case("EXCLUDED") :
        switch(_destination) {
          case("SUMMARY") :
            this.summaryContainer.addAll(_imagesToMove);
            break;
          case("STANDBY") :
            this.standByContainer.addAll(_imagesToMove);
            break;
        }
        break;
      default: break;
    }
    this.printContainersState();
  }

  /**
   * Just Testing
   */
  void printContainersState(){
    print("<<<<<<<<<< Containers >>>>>>>>>>");
    var sizeOf;
    print("-> Summary Container <-");
    sizeOf = this.summaryContainer.length;
    print("Summary container size: " + this.summaryContainer.length.toString());
    for(var i = 0; i < sizeOf; i++){
      print("Element: " + this.summaryContainer.elementAt(i));
    }
    print("-> Summary Container <-");
    print("-> Stand by Container <-");
    sizeOf = this.standByContainer.length;
    print("Stand-by container size: " + this.standByContainer.length.toString());
    for(var i = 0; i < sizeOf; i++){
      print("Element: " + this.standByContainer.elementAt(i));
    }
    print("-> Stand by Container <-");
    print("-> Excluded Container <-");
    sizeOf = this.excludedContainer.length;
    print("Excluded container size: " + this.excludedContainer.length.toString());
    for(var i = 0; i < sizeOf; i++){
      print("Element: " + this.excludedContainer.elementAt(i));
    }
    print("-> Excluded Container <-");
    print("<<<<<<<<<< Containers >>>>>>>>>>");
  }
  
  /*
  List<Thumbnail> getAllThumbnails(){ ///return just thumbnails with dataBaseVersion > arg
    var thumbnails = new List<Thumbnail>();
    Thumbnail thumb;
    var allPhotos = this.helpSearching.values;
    for(photoType photo in allPhotos){
        thumbnails.add(photo.myThumbnail);
      }
    return thumbnails;
  } */
  
  /**
   * Summary Algorithm 
   */
  void workSummary(int numberOfPhotos){
    //TODO
    for(int i = 0; i < numberOfPhotos; i++){
      this.summaryContainer.add(this.standByContainer.elementAt(i));
      this.standByContainer.removeAt(i);
    }
  }
  
  List<Thumbnail> getThumbnails(String fromWhere){
    List<Thumbnail> list = new List<Thumbnail>();
    Thumbnail thumb;
    List<String> container;

    switch(fromWhere){
      case("SUMMARY") :
        container = this.summaryContainer;
        for(String photo in container){
            list.add(this.helpSearching[photo].myThumbnail);
        }
        return list;
        break;
      case("STANDBY") :
        container = this.standByContainer;
        for(String photo in container){
            list.add(this.helpSearching[photo].myThumbnail);
        }
        return list;
        break;
      case("EXCLUDED") :
        container = this.excludedContainer;
        for(String photo in container){
            list.add(this.helpSearching[photo].myThumbnail);
        }
        return list;
      default: break;
      
      return null; //exception ??
    }
 }
  
}//dataBase