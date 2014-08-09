library database;

import '../photo/photo.dart';
import '../photo/similarGroupOfPhotos.dart';
import 'dart:math' as Math;
import 'dart:core';
import '../settings/mementoSettings.dart';
import '../settings/FunctionChoosed.dart' as Function;
import '../categories/categoryManager.dart';
import '../categories/category.dart';
import '../categories/similarCategory.dart' as similar;
import '../exif/exifManager.dart';
import '../hierarchyClustering/clusteringManager.dart';

import 'package:observe/observe.dart';

const String SUMMARY = "SUMMARY";
const String STANDBY = "STANDBY";
const String EXCLUDED = "EXCLUDED";

final DB = Database.get();
final _categoryManager = CategoryManager.get();
final _exifManager = ExifManager.get();
final _clusteringManager = ClusteringManager.get();

class Container extends Object with Observable {
  final String name;
  final String secondname;
  final List<Photo> photos = toObservable(new Set());
  final List<Photo> photosToDisplay = toObservable(new Set());
  List<SimilarGroupOfPhotos> similarListGroupOfPhotos = new List<SimilarGroupOfPhotos>();

  Container(this.name, this.secondname);
  
  String get containerName => name;
  
  void clearData(){
    photos.clear();
    photosToDisplay.clear();
    similarListGroupOfPhotos.clear();
  }
  
  void removeGroupFromList(SimilarGroupOfPhotos similarGroup){
    similarListGroupOfPhotos.remove(similarGroup);
    sortListGroupOfPhotos();
  }
  
  void removePhotoFromGroups(Photo photo){
    similarListGroupOfPhotos.forEach((similarGroup){
      if(similarGroup.giveMeAllPhotos.contains(photo)){
        similarGroup.removeFromList(photo);
      }
    });
    
    sortListGroupOfPhotos();
  }
  
  Photo find(String id) => photos.firstWhere((p) => p.id == id, orElse: () => null);
  
  void tryToEnterInAGroupOrCreateANewOne(Photo photo){
    var matchGroup = returnMatch(photo);
    if(matchGroup != null){
      matchGroup.addToList(photo);
      photo.setSimilarGroup(matchGroup);
    }else{
      SimilarGroupOfPhotos newGroup = new SimilarGroupOfPhotos();
      newGroup.addToList(photo);
      newGroup.setGroupFace(photo);
      photo.setSimilarGroup(newGroup); 
      similarListGroupOfPhotos.add(newGroup);
    }
    
    sortListGroupOfPhotos();
  }
  
  void sortListGroupOfPhotos(){
    
    //similarListGroupOfPhotos.sort();
  }
  
  SimilarGroupOfPhotos returnMatch(Photo photoToAnalyze){
    var similarGroupToReturn = null;
    
    similarListGroupOfPhotos.forEach((similarGroup){
      similarGroup.giveMeAllPhotos.forEach((photo){
        if(photo.similarPhotos.contains(photoToAnalyze)){
          similarGroupToReturn = similarGroup;
          return similarGroupToReturn;
        }
      });
    });
    
    return similarGroupToReturn;
  }
  
  List<Photo> giveMeAllHeader(){
    var listToReturn = new List<Photo>();
    
    similarListGroupOfPhotos.forEach((group){
      listToReturn.add(group.groupFace);
    });
    
    return listToReturn;
  }
  
  bool isFromThisContainer(SimilarGroupOfPhotos similarGroup){
    return similarListGroupOfPhotos.contains(similarGroup);
  }
  
  void showPhotosWithCategories(List<Category> categories, Photo displayingPhoto,
                                 SimilarGroupOfPhotos similarGroupChoosed){
    photosToDisplay.clear();
    if(categories.length == 0){
      photosToDisplay.addAll(photos);
    }else{
      if(displayingPhoto != null){
        //BIG SIZE PHOTO SCREEN
        if(categories.contains(similar.SimilarCategory.get())){
          if(photos.contains(displayingPhoto)){
            photosToDisplay.add(displayingPhoto);
          }
          
          displayingPhoto.similarPhotos.forEach((photoSimilar){
            if(photos.contains(photoSimilar)){
              photosToDisplay.add(photoSimilar);
            }
          });

          if(categories.length > 1){
            var addThisPhoto = false;
            photosToDisplay.forEach((photoToDisplay){
              categories.forEach((category){
                if(!(category == similar.SimilarCategory.get())){
                  addThisPhoto = photoToDisplay.containsCategory(category);
                }       
              });
              if(!addThisPhoto){
                photosToDisplay.remove(photoToDisplay);
              }
            });
          }
        }else{
          //TODO BIG SIZE PHOTO WITHOUT SIMILAR SELECTED
          var addThisOne = false;
                photos.forEach((photo){
                  categories.forEach((category){
                    addThisOne = photo.containsCategory(category);
                  });
                  if(addThisOne){
                    photosToDisplay.add(photo);
                  }  
                });
        }
      }//DisplayingPhoto != null
      //SUMMARY DONE SCREEN
      else if(categories.contains(similar.SimilarCategory.get())){    
        if(similarGroupChoosed != null && isFromThisContainer(similarGroupChoosed)){
          photosToDisplay.addAll(similarGroupChoosed.giveMeAllPhotos);
        }else{
          photosToDisplay.addAll(giveMeAllHeader());
        }
        if(categories.length > 1){
          var addThisPhoto = false;
          photosToDisplay.forEach((photoToDisplay){
            categories.forEach((category){
              if(!(category == similar.SimilarCategory.get())){
                addThisPhoto = photoToDisplay.containsCategory(category);
              }       
            });
            if(!addThisPhoto){
              photosToDisplay.remove(photoToDisplay);
            }
          });
        }
      }else{
      var addThisOne = false;
      photos.forEach((photo){
        categories.forEach((category){
          addThisOne = photo.containsCategory(category);
        });
        if(addThisOne){
          photosToDisplay.add(photo);
        }  
      });
    }//End of Summary Done 
   }//If categories selected > 0
  }

  bool equals(Container otherContainer){
    return this.name == otherContainer.name;
  }
}

class Database extends Object with Observable {
  
  Photo photoToDisplay;
  MementoSettings _settings = MementoSettings.get();
  final Map<String, Container> containers = toObservable({});
  /*BigSizePhoto screen need this*/
  final String SUMMARY = "SUMMARY";
  final String STANDBY = "STANDBY";
  final String EXCLUDED = "EXCLUDED";
  final String SUMMARY2 = "SUMMARY2";
  final String STANDBY2 = "STANDBY2";
  final String EXCLUDED2 = "EXCLUDED2";

  /**
   * Singleton
   */
  static Database _instance;
 
  Database._() {
    var containersToBuild = [SUMMARY, STANDBY, EXCLUDED, SUMMARY2, STANDBY2, EXCLUDED2];
    var leng = ((containersToBuild.length)/2).round();
    for(int i = 0; i<leng; i++){
      containers[containersToBuild.elementAt(i)] = new Container(containersToBuild.elementAt(i), 
                                                       containersToBuild.elementAt(i+leng));
    }
  }

  static Database get() {
    if (_instance == null) {
      _instance = new Database._();
    }
    return _instance;
  }

  Photo find(String id) {
    var aux;
    var photo;
    containers.forEach((_, c) {
      aux  = c.find(id);
      if(aux!=null){
        photo = aux;
      }
    });
    return photo;
  }
  
  Container findContainer(String photoID){
   var _container;
   var aux;
   containers.forEach((_, container){
     aux = container.find(photoID);
     if(aux!=null){
       _container = container;
     }
   }); 
   return _container;
  }
   
  Photo get photoToDisplayPlease => photoToDisplay;
  
  void setPhotoToDisplay(String id){
    photoToDisplay = find(id);
  }
  
  double extractExifInformation(Photo photo){
    return _exifManager.extractExifInformation(photo);
  }
  
  /**
   *  Used when Photos are beeing uploaded. We need to normalize data
   *  information so we can sort all photos directly in the same screen
   */ 
  double firstNormalization(DateTime date){
    return _exifManager.firstNormalization(date);
  }
  
  /**
   * Used when all photos are uploaded and the user informs to start the summary build.
   * All integer that represents DateTime are now normalized between 0 and 1.
   */ 
  void secondNormalization(){
    _exifManager.secondNormalization(container(STANDBY).photos);
  }

  /**
   * Add a new element to the database
   */
  void addNewElementsToDataBase(List<Photo> photos){
    container(STANDBY).photos.addAll(photos);
    container(STANDBY).photosToDisplay.addAll(photos);
  }

  /**
   * Add to container
   */
  void addToContainer(String name, List<Photo> photos) {
    container(name).photos.addAll(photos);
    container(name).photosToDisplay.addAll(photos);
  }

  Container container(String name) => containers[name];

  /**
   * Add to container
   */
  void moveFromTo(String origin, String destination , Iterable<Photo> photos){
    photos.forEach((p) {
      container(origin).photos.remove(p);
      container(origin).photosToDisplay.remove(p);
      container(destination).photos.add(p);
      container(destination).photosToDisplay.add(p);
    });
    
    sortPhotos(container(origin).photos);
    sortPhotos(container(origin).photosToDisplay);
    sortPhotos(container(destination).photos);
    sortPhotos(container(destination).photosToDisplay);
  }

  /**
   * Clean Database data
   * 
   */ 
  bool cleanAllData(){
    var result = true;
    
    containers.forEach((containerName, container){
      container.clearData();
    });
    
    photoToDisplay = null;
    
    return result;
  }
  
  /**
   * Build Summary
   */
  bool buildSummary(List<Photo> photos, int numberOfPhotosDefined){
    addNewElementsToDataBase(photos);
    decideAlgorithm(numberOfPhotosDefined);
    return true;
  }
  
  /**
   * Decide which algorithm to use in the summary creation
   */
  void decideAlgorithm(int numberOfPhotos){
    var function = _settings.whichAlgorithmInUse();
    extractCategories();
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
    /*After clustering - Category extraction - Similarity*/
    var container = containers.values.elementAt(0);
    container.similarListGroupOfPhotos.addAll(similar.SimilarCategory.get().workSimilarCase(container.photos));
    container.sortListGroupOfPhotos();
    container = containers.values.elementAt(1);
    container.similarListGroupOfPhotos.addAll(similar.SimilarCategory.get().workSimilarCase(container.photos));
    container.sortListGroupOfPhotos();
    container = containers.values.elementAt(2);
    container.similarListGroupOfPhotos.addAll(similar.SimilarCategory.get().workSimilarCase(container.photos));
    container.sortListGroupOfPhotos();
  }
  
  /**
   *  Categories extraction
   */ 
  void extractCategories(){
    _categoryManager.categoriesPipeline(container(STANDBY).photos);
  }

  /**
   * First X photos
   */
  void workFirstXSummary(int numberOfPhotos){
    var photos = container(STANDBY).photos.take(numberOfPhotos).toList();
    moveFromTo(STANDBY, SUMMARY, photos);
  }

  /**
   * For random tests
   */
  void buildRandomSummary(int numberOfPhotos){
    var rnd = new Math.Random(),
        max = container(STANDBY).photos.length,
        photo;
    for(int i = 0; i < numberOfPhotos; i++){
      photo = container(STANDBY).photos.elementAt(rnd.nextInt(max));
      container(SUMMARY).photos.add(photo);
      container(SUMMARY).photosToDisplay.add(photo);
      container(STANDBY).photos.remove(photo);
      container(STANDBY).photosToDisplay.remove(photo);
    }
  }

  /**
   * With cluster algorithm
   */
  void buildClusterSummary(int numberOfPhotos){
        
    secondNormalization();
    print("CLUSTERING");
    var summaryPhotos = _clusteringManager.doClustering(container(STANDBY).photos, numberOfPhotos,
        container(STANDBY).photos.length);
    print("ACABEI O CLUSTERING");
    moveFromTo(STANDBY, SUMMARY, summaryPhotos);
      
    printContainersState(); //TODO
  }
  
  /**
   *  Method to sort Photos
   */ 
  List<Photo> sortPhotos(List<Photo> photos){
    var aux = photos;
    aux.sort();
    return aux;
  }

  /**
   *
   */
  void printContainersState(){
    print("<<<<<<<<<< Containers >>>>>>>>>>");
    var sizeOf;
    containers.forEach((key, container) {
      print("-> $key Container <-");
      print("$key container size: ${container.photos.length}");
      container.photos.forEach((p) {
        print("Element: $p");
      });
    });
  }

}//dataBase