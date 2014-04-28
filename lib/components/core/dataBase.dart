import 'photoType.dart';
import 'dart:html';

class dataBase {
  
  //?
  bool start;
  
  dataBase.created();
  
  dataBase(bool start);
  
  //Save photoType elements
  List<String> newNameToAddToMap;
  //List<photoType> dataBaseImage = new List<photoType>();
  Map<String, photoType> helpSearching = new Map<String, photoType>();
  
  //Containers (Just contain file names)
  List<String> summaryContainer = new List<String>();
  List<String> standByContainer = new List<String>();
  List<String> excludedContainer = new List<String>();
  
  //Aux
  Map<String, photoType> map = null;
  List<String> namesToAdd = new List<String>();
  List<photoType> newDataBaseElementsToAdd = new List <photoType>();
  photoType newDataBaseElement = null;

  void addNewElementsToDataBase(List<File> originalFiles, List<ImageElement> thumbnailFiles){
  int fileListSize = originalFiles.length;
  for(int i = 0; i < fileListSize; i++){
    //if does not exists in the library
    if(!alreadyExistsInTheDataBase(originalFiles.elementAt(i))){
      this.namesToAdd.add(originalFiles.elementAt(i).name);
      this.newDataBaseElement = new photoType(originalFiles.elementAt(i), thumbnailFiles.elementAt(i));        
      this.newDataBaseElementsToAdd.add(this.newDataBaseElement);
    }
  }//ciclo for
    
  print("---------- Before update --------");
  print("Names To add size: " + this.namesToAdd.length.toString());
  print("New Elements to Add size: " + this.newDataBaseElementsToAdd.length.toString());
  print("New element is null? " + this.newDataBaseElement.toString());
  print("---------- Before update --------");
  
    //Updating the dataBase
    this.updateMap(this.namesToAdd, this.newDataBaseElementsToAdd);
    //this.updateListDataBaseElements(this.newDataBaseElementsToAdd);
    
    //TODO CHANGE THIS
    this.addToStandByContainer(this.namesToAdd);
    
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
  
  //TODO test
  void printContainersState(){
    print("<<<<<<<<<< Containers >>>>>>>>>>");
    int sizeOf;
    print("-> Summary Container <-");
    sizeOf = this.summaryContainer.length;
    print("Summary container size: " + this.summaryContainer.length.toString());   
    for(int i = 0; i < sizeOf; i++){
      print("Element: " + this.summaryContainer.elementAt(i));
    }
    print("-> Summary Container <-");
    print("-> Stand by Container <-");
    sizeOf = this.standByContainer.length;
    print("Stand-by container size: " + this.standByContainer.length.toString());   
    for(int i = 0; i < sizeOf; i++){
      print("Element: " + this.standByContainer.elementAt(i));
    }
    print("-> Stand by Container <-");
    print("-> Excluded Container <-");
    sizeOf = this.excludedContainer.length;
    print("Excluded container size: " + this.excludedContainer.length.toString());   
    for(int i = 0; i < sizeOf; i++){
      print("Element: " + this.excludedContainer.elementAt(i));
    }
    print("-> Excluded Container <-");
    print("<<<<<<<<<< Containers >>>>>>>>>>");
  }
  
  /**
   * Update Map
   */
  void updateMap(List<String> newNames, List<photoType> newDataBaseElements){
    this.map = new Map.fromIterables(newNames, newDataBaseElements);
    this.helpSearching.addAll(map);
    this.map = null;  
  }
  
  /**
     * Update List of dataBase Elements
     */
  /*
  void updateListDataBaseElements(List<photoType> newElementsToAdd){
    this.dataBaseImage.addAll(newElementsToAdd);
  }*/
  
  /**
   * Check if already exists in the database
   */
  bool alreadyExistsInTheDataBase(File file){
    return this.helpSearching.containsKey(file.name);
  }
  
  //Containers area
  
  List<photoType> giveYourSummaryPhotos(){
    List<photoType> summaryPhotos = new List<photoType>();  
    List<String> inSummary = this.summaryContainer;
    int inSummarySize = inSummary.length;
      for(int i = 0; i < inSummarySize; i++){
        summaryPhotos.add(this.helpSearching[inSummary.elementAt(i)]);
      }
    return summaryPhotos;  
  }
  
  List<photoType> giveYourStandByPhotos(){
    List<photoType> standByPhotos = new List<photoType>();  
    List<String> inStandBy = this.standByContainer;
    int inStandBySize = inStandBy.length;
      for(int i = 0; i < inStandBySize; i++){
        standByPhotos.add(this.helpSearching[inStandBy.elementAt(i)]);
      }
    return standByPhotos;  
  }
  
  List<photoType> giveYourExcludedPhotos(){
    List<photoType> excludedPhotos = new List<photoType>();  
    List<String> inExcluded = this.excludedContainer;
    int inSummarySize = inExcluded.length;
      for(int i = 0; i < inSummarySize; i++){
        excludedPhotos.add(this.helpSearching[inExcluded.elementAt(i)]);
      }
    return excludedPhotos;  
  }
  
  void addToSummaryContainer(List<String> imagesToAdd){
    this.summaryContainer.addAll(imagesToAdd);
    print(" << ADDING TO SUMMARY CONTAINER >>");
    this.printContainersState(); //TODO
    print(" << ADDING TO SUMMARY CONTAINER >>");
  }
  
  void addToStandByContainer(List<String> imagesToAdd){
    this.standByContainer.addAll(imagesToAdd);
    print(" << ADDING TO STAND-BY CONTAINER >>");
    this.printContainersState(); //TODO
    print(" << ADDING TO STAND-BY CONTAINER >>");
  }
  
  void addToExcludedContainer(List<String> imagesToAdd){
    this.excludedContainer.addAll(imagesToAdd);
    print(" << ADDING TO EXCLUDED CONTAINER >>");
    this.printContainersState(); //TODO
    print(" << ADDING TO EXCLUDED CONTAINER >>");
  }
  
  //TODO REFACTORIZAR
  /**
   * 
   */
  void fromSummaryToStandBy(List<String> summaryToStandBy){
    this.standByContainer.addAll(summaryToStandBy); 
    print(" << FROM SUMMARY TO STANDBY CONTAINER >>");
    this.printContainersState(); //TODO
    print(" << FROM SUMMARY TO STANDBY CONTAINER >>");
  }
  
  /**
   * 
   */
  void fromSummaryToExcluded(List<String> summaryToExcluded){
    this.excludedContainer.addAll(summaryToExcluded); 
    print(" << FROM SUMMARY TO EXCLUDED CONTAINER >>");
    this.printContainersState(); //TODO
    print(" << FROM SUMMARY TO EXCLUDED CONTAINER >>");
    
  }
  /**
   * 
   */
  void fromStandByToSummary(List<String> standByToSummary){
    this.summaryContainer.addAll(standByToSummary);
    print(" << FROM STANDBY TO SUMMARY CONTAINER >>");
    this.printContainersState(); //TODO
    print(" << FROM STANDBY TO SUMMARY CONTAINER >>");
  }
  
  /**
   * 
   */
  void fromStandByToExcluded(List<String> standByToExcluded){
    this.excludedContainer.addAll(standByToExcluded);   
    print(" << FROM STANDBY TO EXCLUDED CONTAINER >>");
    this.printContainersState(); //TODO
    print(" << FROM STANDBY TO EXCLUDED CONTAINER >>");
  }
  /**
   * 
   */
  void fromExcludedToSummary(List<String> excludedToSummary){
    this.summaryContainer.addAll(excludedToSummary); 
    print(" << FROM EXCLUDED TO SUMMARY CONTAINER >>");
    this.printContainersState(); //TODO
    print(" << FROM EXCLUDED TO SUMMARY CONTAINER >>");
  }
  
  /**
   * 
   */
  void fromExcludedToStandBy(List<String> excludedToStandBy){
    this.standByContainer.addAll(excludedToStandBy); 
    print(" << FROM EXCLUDED TO STANDBY CONTAINER >>");
    this.printContainersState(); //TODO
    print(" << FROM EXCLUDED TO STANDBY CONTAINER >>");
  }
  
  
  //TODO REFACTORIZAR 
  /*
  void removeFromSummaryContainer(List<photoType> imagesToRemove){
    int imagesToRemoveSize = imagesToRemove.length;
    File file;
    for(int i = 0; i < imagesToRemoveSize; i++){
      file = imagesToRemove.elementAt(i).myFile;
      this.summaryContainer.remove(file.name);
    }
  }
  
  void removeFromStandByContainer(List<photoType> imagesToRemove){
    int imagesToRemoveSize = imagesToRemove.length;
    File file;
    for(int i = 0; i < imagesToRemoveSize; i++){
      file = imagesToRemove.elementAt(i).myFile;
      this.standByContainer.remove(file.name);
    }
  }
  
  void removeFromExcludedContainer(List<photoType> imagesToRemove){
    int imagesToRemoveSize = imagesToRemove.length;
    File file;
    for(int i = 0; i < imagesToRemoveSize; i++){
      file = imagesToRemove.elementAt(i).myFile;
      this.excludedContainer.remove(file.name);
    }
  }*/ 
}//dataBase