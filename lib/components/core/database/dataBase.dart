library database;

import '../photo/photo.dart';
import '../photo/GroupOfPhotos/similarGroupOfPhotos.dart';
import '../photo/GroupOfPhotos/facesGroupOfPhotos.dart';
import '../photo/GroupOfPhotos/colorGroupOfPhotos.dart';
import '../photo/GroupOfPhotos/qualityGroupOfPhotos.dart';
import '../photo/GroupOfPhotos/dayMomentGroupOfPhotos.dart';
import '../photo/GroupOfPhotos/groupOfPhotos.dart';

import '../settings/mementoSettings.dart';
import '../settings/FunctionChoosed.dart' as Function;
import '../categories/categoryManager.dart';
import '../categories/category.dart';
import '../categories/facesCategory.dart' as faces;
import '../categories/dayMomentCategory.dart' as dayMoment;
import '../categories/toningCategory.dart' as color;
import '../categories/qualityCategory.dart' as quality;
import '../categories/similarCategory.dart' as similar;

import 'package:observe/observe.dart';
import 'dart:math' as Math;
import 'dart:core';
import 'dart:html';
import 'dart:async';

import '../exif/exifManager.dart';
import '../hierarchyClustering/clusteringManager.dart';
import 'dataBaseAuxiliarFunctions.dart';

const String SUMMARY = "SUMMARY";
const String STANDBY = "STANDBY";
const String EXCLUDED = "EXCLUDED";

final DB = Database.get();
final _categoryManager = CategoryManager.get();
final _exifManager = ExifManager.get();
final _clusteringManager = ClusteringManager.get();
final _databaseAuxiliarFunctions = DatabaseAuxiliarFunctions.get();

/**
 * 
 */
class Container extends Object with Observable {
  final String name;
  final String secondname;
  final List<Photo> photos = toObservable(new Set());
  final List<Photo> photosToDisplay = toObservable(new Set());
  List<GroupOfPhotos> facesListGroupOfPhotos = new List<FacesGroupOfPhotos>();
  List<GroupOfPhotos> dayMomentListGroupOfPhotos = new List<DayMomentGroupOfPhotos>();
  List<GroupOfPhotos> colorListGroupOfPhotos = new List<ColorGroupOfPhotos>();
  List<GroupOfPhotos> qualityListGroupOfPhotos = new List<QualityGroupOfPhotos>();
  List<GroupOfPhotos> similarListGroupOfPhotos = new List<SimilarGroupOfPhotos>();

  Container(this.name, this.secondname);

  /**
   * 
   */
  String get containerName => name;

  /**
   * 
   */
  bool containerHasThatName(String name) {
    var pics = photos.where((photo) => photo.title == name);
    return pics.isNotEmpty;
  }
  
  /**
   * 
   */
  Photo find(String id) => photos.firstWhere((p) => p.id == id, orElse: () => null);

  /**
   * 
   */
  List<List<GroupOfPhotos>> allContainerGroups() {
    var listToReturn = new List<List<GroupOfPhotos>>();
    listToReturn.add(facesListGroupOfPhotos);
    listToReturn.add(dayMomentListGroupOfPhotos);
    listToReturn.add(colorListGroupOfPhotos);
    listToReturn.add(qualityListGroupOfPhotos);
    listToReturn.add(similarListGroupOfPhotos);

    return listToReturn;
  }


  /*
   * 
   */
  void clearData() {
    photos.clear();
    photosToDisplay.clear();
    similarListGroupOfPhotos.clear();
    facesListGroupOfPhotos.clear();
    colorListGroupOfPhotos.clear();
    qualityListGroupOfPhotos.clear();
    dayMomentListGroupOfPhotos.clear();
  }
  
  /**
   * 
   */
  void clearTheRightGroup(GroupOfPhotos group, List<GroupOfPhotos> list){
    list.forEach((element){
      if(element.groupName == group.groupName){element.clear();}
    });  
  }

  /*
   * 
   */
  void removeGroupFromList(GroupOfPhotos group) {
    switch (group.groupName) {
      case "With Faces":
        clearTheRightGroup(group, facesListGroupOfPhotos);
        sortListGroupOfPhotos(facesListGroupOfPhotos);
        break;
      case "Without Faces":
        clearTheRightGroup(group, facesListGroupOfPhotos);
        sortListGroupOfPhotos(facesListGroupOfPhotos);
        break;
      case "Night":
        clearTheRightGroup(group, dayMomentListGroupOfPhotos);
        sortListGroupOfPhotos(dayMomentListGroupOfPhotos);
        break;
      case "Day":
        clearTheRightGroup(group, dayMomentListGroupOfPhotos);
        sortListGroupOfPhotos(dayMomentListGroupOfPhotos);
        break;
      case "Color":
        clearTheRightGroup(group, colorListGroupOfPhotos);
        sortListGroupOfPhotos(colorListGroupOfPhotos);
        break;
      case "Black and White":
        clearTheRightGroup(group, colorListGroupOfPhotos);
        sortListGroupOfPhotos(colorListGroupOfPhotos);
        break;
      case "Good Quality":
        clearTheRightGroup(group, qualityListGroupOfPhotos);
        sortListGroupOfPhotos(qualityListGroupOfPhotos);
        break;
      case "Medium Quality":
        clearTheRightGroup(group, qualityListGroupOfPhotos);
        sortListGroupOfPhotos(qualityListGroupOfPhotos);
        break;
      case "Bad Quality":
        clearTheRightGroup(group, qualityListGroupOfPhotos);
        sortListGroupOfPhotos(qualityListGroupOfPhotos);
        break;
      case "Similar":
        similarListGroupOfPhotos.remove(group);
        sortListGroupOfPhotos(similarListGroupOfPhotos);
        break;
      default:
        break;
    }
  }

  /*
   * 
   */
  void removePhotoFromGroups(Photo photo, GroupOfPhotos group) {
    var listToSort = null;
    switch (group.groupName) {
      case "With Faces":
        listToSort = facesListGroupOfPhotos;
        facesListGroupOfPhotos.forEach((facesGroup) {
          if (facesGroup.giveMeAllPhotos.contains(photo)) {
            facesGroup.removeFromList(photo);
          }
        });
        break;
      case "Without Faces":
        listToSort = facesListGroupOfPhotos;
        facesListGroupOfPhotos.forEach((facesGroup) {
          if (facesGroup.giveMeAllPhotos.contains(photo)) {
            facesGroup.removeFromList(photo);
          }
        });
        break;
      case "Night":
        listToSort = dayMomentListGroupOfPhotos;
        dayMomentListGroupOfPhotos.forEach((dayMomentGroup) {
          if (dayMomentGroup.giveMeAllPhotos.contains(photo)) {
            dayMomentGroup.removeFromList(photo);
          }
        });
        break;
      case "Day":
        listToSort = dayMomentListGroupOfPhotos;
        dayMomentListGroupOfPhotos.forEach((dayMomentGroup) {
          if (dayMomentGroup.giveMeAllPhotos.contains(photo)) {
            dayMomentGroup.removeFromList(photo);
          }
        });
        break;
      case "Color":
        listToSort = colorListGroupOfPhotos;
        colorListGroupOfPhotos.forEach((colorGroup) {
          if (colorGroup.giveMeAllPhotos.contains(photo)) {
            colorGroup.removeFromList(photo);
          }
        });
        break;
      case "Black and White":
        listToSort = colorListGroupOfPhotos;
        colorListGroupOfPhotos.forEach((colorGroup) {
          if (colorGroup.giveMeAllPhotos.contains(photo)) {
            colorGroup.removeFromList(photo);
          }
        });
        break;
      case "Good Quality":
        listToSort = qualityListGroupOfPhotos;
        qualityListGroupOfPhotos.forEach((qualityGroup) {
          if (qualityGroup.giveMeAllPhotos.contains(photo)) {
            qualityGroup.removeFromList(photo);
          }
        });
        break;
      case "Medium Quality":
        listToSort = qualityListGroupOfPhotos;
        qualityListGroupOfPhotos.forEach((qualityGroup) {
          if (qualityGroup.giveMeAllPhotos.contains(photo)) {
            qualityGroup.removeFromList(photo);
          }
        });
        break;
      case "Bad Quality":
        listToSort = qualityListGroupOfPhotos;
        qualityListGroupOfPhotos.forEach((qualityGroup) {
          if (qualityGroup.giveMeAllPhotos.contains(photo)) {
            qualityGroup.removeFromList(photo);
          }
        });
        break;
      case "Similar":
        listToSort = similarListGroupOfPhotos;
        similarListGroupOfPhotos.forEach((similarGroup) {
          if (similarGroup.giveMeAllPhotos.contains(photo)) {
            similarGroup.removeFromList(photo);
          }
        });
        break;
      default:
        break;
    }

    sortListGroupOfPhotos(listToSort);
  }

  /**
   * 
   */
  void sortEverything() {
    sortListGroupOfPhotos(facesListGroupOfPhotos);
    sortListGroupOfPhotos(dayMomentListGroupOfPhotos);
    sortListGroupOfPhotos(colorListGroupOfPhotos);
    sortListGroupOfPhotos(qualityListGroupOfPhotos);
    sortListGroupOfPhotos(similarListGroupOfPhotos);
  }

  /**
   * 
   */
  void sortListGroupOfPhotos(List<GroupOfPhotos> listToSort){
    listToSort.sort();
  }

  List<GroupOfPhotos> giveMeTheCorrectListOfGroups(GroupOfPhotos group) {
    var listToReturn = null;
    switch (group.groupName) {
      case "With Faces":
        listToReturn = facesListGroupOfPhotos;
        break;
      case "Without Faces":
        listToReturn = facesListGroupOfPhotos;
        break;
      case "Night":
        listToReturn = dayMomentListGroupOfPhotos;
        break;
      case "Day":
        listToReturn = dayMomentListGroupOfPhotos;
        break;
      case "Color":
        listToReturn = colorListGroupOfPhotos;
        break;
      case "Black and White":
        listToReturn = colorListGroupOfPhotos;
        break;
      case "Good Quality":
        listToReturn = qualityListGroupOfPhotos;
        break;
      case "Medium Quality":
        listToReturn = qualityListGroupOfPhotos;
        break;
      case "Bad Quality":
        listToReturn = qualityListGroupOfPhotos;
        break;
      case "Similar":
        listToReturn = similarListGroupOfPhotos;
        break;
      default:
        break;
    }
    return listToReturn;
  }

  GroupOfPhotos instanceTheCorrectGroup(GroupOfPhotos group) {
    var correctGroup = null;
    switch (group.groupName) {
      case "With Faces":
        FacesGroupOfPhotos withFaces = new FacesGroupOfPhotos();
        withFaces.setGroupName("With Faces");
        correctGroup = withFaces;
        break;
      case "Without Faces":
        FacesGroupOfPhotos faces = new FacesGroupOfPhotos();
        faces.setGroupName("Without Faces");
        correctGroup = faces;
        break;
      case "Night":
        DayMomentGroupOfPhotos night = new DayMomentGroupOfPhotos();
        night.setGroupName("Night");
        correctGroup = night;
        break;
      case "Day":
        DayMomentGroupOfPhotos day = new DayMomentGroupOfPhotos();
        day.setGroupName("Day");
        correctGroup = day;
        break;
      case "Color":
        ColorGroupOfPhotos color = new ColorGroupOfPhotos();
        color.setGroupName("Color");
        correctGroup = color;
        break;
      case "Black and White":
        ColorGroupOfPhotos blackAndWhite = new ColorGroupOfPhotos();
        blackAndWhite.setGroupName("Black and White");
        correctGroup = blackAndWhite;
        break;
      case "Good Quality":
        QualityGroupOfPhotos goodQuality = new QualityGroupOfPhotos();
        goodQuality.setGroupName("Good Quality");
        correctGroup = goodQuality;
        break;
      case "Medium Quality":
        QualityGroupOfPhotos mediumQuality = new QualityGroupOfPhotos();
        mediumQuality.setGroupName("Medium Quality");
        correctGroup = mediumQuality;
        break;
      case "Bad Quality":
        QualityGroupOfPhotos badQuality = new QualityGroupOfPhotos();
        badQuality.setGroupName("Bad Quality");
        correctGroup = badQuality;
        break;
      case "Similar":
        SimilarGroupOfPhotos similar = new SimilarGroupOfPhotos();
        similar.setGroupName("Similar");
        correctGroup = similar;
        break;
      default:
        break;
    }
    return correctGroup;
  }

  void putItIntoTheCorrectList(GroupOfPhotos group) {
    switch (group.groupName) {
      case "With Faces":
        facesListGroupOfPhotos.add(group);
        break;
      case "Without Faces":
        facesListGroupOfPhotos.add(group);
        break;
      case "Night":
        dayMomentListGroupOfPhotos.add(group);
        break;
      case "Day":
        dayMomentListGroupOfPhotos.add(group);
        break;
      case "Color":
        colorListGroupOfPhotos.add(group);
        break;
      case "Black and White":
        colorListGroupOfPhotos.add(group);
        break;
      case "Good Quality":
        qualityListGroupOfPhotos.add(group);
        break;
      case "Medium Quality":
        qualityListGroupOfPhotos.add(group);
        break;
      case "Bad Quality":
        qualityListGroupOfPhotos.add(group);
        break;
      case "Similar":
        similarListGroupOfPhotos.add(group);
        break;
      default:
        break;
    }
  }

  void tryToEnterInAGroupOrCreateANewOne(GroupOfPhotos groupOfPhotos, Photo photo) {
    print("!!!!!!!!!!!!!! Photo: " + photo.id.toString() + " tem este numero de semelhantes: " + photo.similarPhotos.length.toString());
    photo.similarPhotos.forEach((similarPhoto) {
      print("Nome: " + similarPhoto.id.toString());
    });
    print(">>>>>Lets try to enter in a group or create a new one<<<<<");

    var listOfGroupsAux = giveMeTheCorrectListOfGroups(groupOfPhotos),
        listOfGroups = new List<GroupOfPhotos>(),
        groupName = groupOfPhotos.groupName;
        listOfGroups.addAll(listOfGroupsAux.toList());   
    print("Enter with this type of Group: " + groupOfPhotos.groupName.toString());
    print("Correct List Of Groups of this type: " + listOfGroups.length.toString());

    //Criar um grupo
    if ((listOfGroups == null) || (listOfGroups.length == 0)) {
      print("Vou ter que criar um grupo: " + groupOfPhotos.groupName.toString() + "pois ele ainda nao existe neste container");
      var newGroup = instanceTheCorrectGroup(groupOfPhotos);
      photo.addGroup(newGroup);
      newGroup.setGroupFace(photo);
      newGroup.addToList(photo);
      putItIntoTheCorrectList(newGroup);
    } else {
      print("Lista nao esta vazia");
      listOfGroups.forEach((group) {
        if (groupOfPhotos.groupName == "Similar") {       
          print("Percorrendo as similar");
          var groupAllPhotos = new List<Photo>();
          groupAllPhotos.addAll(group.giveMeAllPhotos);
          groupAllPhotos.forEach((photoInsideGroup) {
            print("As semelhantes de: " + photoInsideGroup.id + " sao: " + photoInsideGroup.similarPhotos.toString());
            if (photoInsideGroup.similarPhotos.contains(photo) && !group.giveMeAllPhotos.contains(photo)) {
              print("Sou uma das semelhantes em relacao a foto que ja aqui estava");
              photo.addGroup(group);
              group.addToList(photo);
              group.sort();
            } else {
              var secondLevelPhotos = new List<Photo>();
              secondLevelPhotos.addAll(photoInsideGroup.similarPhotos);
              secondLevelPhotos.forEach((secondLevelPhoto) {
                if (secondLevelPhoto.similarPhotos.contains(photo) && !group.giveMeAllPhotos.contains(photo)) {
                  print("Sou semelhante a uma semelhante em relacao a foto que ja aqui estava");
                  photo.addGroup(group);
                  group.addToList(photo);
                  group.sort();
                }
              });
            }
          });
          if((photo.returnSimilarGroup == null) && (listOfGroups.last == group)){
            SimilarGroupOfPhotos similarGroup = new SimilarGroupOfPhotos();
            similarGroup.setGroupName("Similar");
            similarGroup.setGroupFace(photo);
            similarGroup.addToList(photo);
            photo.addGroup(similarGroup);
            similarListGroupOfPhotos.add(similarGroup);
          }
        } else {
          print("VOU ENTRAR AQUI !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
          print("Group name to enter: " + group.groupName.toString());
          if (group.groupName == groupOfPhotos.groupName) {
            if (group.giveMeAllPhotos.length == 0){
              group.setGroupFace(photo);
            }
            photo.addGroup(group);
            group.addToList(photo);
            group.sort();
            print("Adicionado ao grupo: " + group.groupName.toString());
          }
        }
        print("Number of Elements: " + listOfGroups.length.toString()); 
      });
    }

    sortEverything();
    print(">>>>>Lets try to enter in a group or create a new one<<<<<");
  }
  
  bool existsWithThatName(GroupOfPhotos group, List<GroupOfPhotos> groups){
    var returnValue = false;
    
    groups.forEach((element){
      if(element.groupName == group.groupName){return true;}
    });
    return returnValue;
  }
  
  
  
  List<Photo> giveMeAllHeaderFromThisList(List<Photo> similarPhotos, GroupOfPhotos group){
    var listToReturn = new List<Photo>(),
        correctList = giveMeTheCorrectListOfGroups(group),
        groupPhotos;
    
    correctList.forEach((groupOfTheList) {
      if (groupOfTheList.giveMeAllPhotos.isNotEmpty) {
        groupPhotos = groupOfTheList.giveMeAllPhotos;
        var gotIt = false;
        groupPhotos.forEach((photoInsideGroup){
          if(similarPhotos.contains(photoInsideGroup)){
            if(!gotIt){
              listToReturn.add(photoInsideGroup);
              gotIt = true;
            }
          }
        });
      }
    });
    
    return listToReturn;
  }

  List<Photo> giveMeAllHeader(GroupOfPhotos group) {
    var listToReturn = new List<Photo>(),
        correctList = giveMeTheCorrectListOfGroups(group);
        
    correctList.forEach((groupOfTheList) {
      if (groupOfTheList.giveMeAllPhotos.isNotEmpty){
        listToReturn.add(groupOfTheList.groupFace);
      }
    });

    return listToReturn;
  }

  bool isFromThisContainer(GroupOfPhotos group) {
    var list = giveMeTheCorrectListOfGroups(group);
    return list.contains(group);
  }

  void showPhotosWithCategories(List<Category> categories, Photo displayingPhoto, 
                                GroupOfPhotos groupChoosed, bool normalMode) {
    photosToDisplay.clear();
    if (categories.length == 0) {
      photosToDisplay.addAll(photos); //CASO GERAL
    } else {
      if (displayingPhoto != null && !normalMode) { //BIG SIZE PHOTO SCREEN

          if (photos.contains(displayingPhoto)) {
            photosToDisplay.add(displayingPhoto);
          }
          displayingPhoto.similarPhotos.forEach((photoSimilar) {
            if (photos.contains(photoSimilar)) {
              photosToDisplay.add(photoSimilar);
            }
          });     
            if (categories.length > 1) {
              if (groupChoosed.giveMeAllPhotos.isNotEmpty && isFromThisContainer(groupChoosed)) {
                var photosFromGroup = groupChoosed.giveMeAllPhotos,
                    photosToDisplayNext = new List<Photo>();
                photosToDisplayNext.addAll(photosToDisplay.toList());
                photosToDisplay.clear();
                photosFromGroup.forEach((photoInsideGroup){
                  if(photosToDisplayNext.contains(photoInsideGroup)){
                    photosToDisplay.add(photoInsideGroup);
                  }
                });
              } else {
                var photosToDisplaySaved = new List<Photo>();
                photosToDisplaySaved.addAll(photosToDisplay.toList());
                photosToDisplay.clear();
                photosToDisplay.addAll(giveMeAllHeaderFromThisList(photosToDisplaySaved ,groupChoosed));
              }
            }
      } //DisplayingPhoto != null
      else {
        if (groupChoosed.giveMeAllPhotos.isEmpty && categories.isEmpty) {
          photosToDisplay.addAll(photos);
        } else if (categories.isNotEmpty){
          if (groupChoosed.giveMeAllPhotos.isNotEmpty && isFromThisContainer(groupChoosed)) {
            photosToDisplay.addAll(groupChoosed.giveMeAllPhotos);
          } else {
            photosToDisplay.addAll(giveMeAllHeader(groupChoosed));
          }
        }
      }
    }
  }

  /*
   * 
   */
  bool equals(Container otherContainer) => this.name == otherContainer.name;
}

/**
 * 
 */
class Database extends Object with Observable {

  Photo photoToDisplay;
  MementoSettings _settings = MementoSettings.get();
  final Map<String, Container> containers = toObservable({});
  final String SUMMARY = "SUMMARY";
  final String STANDBY = "STANDBY";
  final String EXCLUDED = "EXCLUDED";
  final String SUMMARY2 = "SUMMARY2";
  final String STANDBY2 = "STANDBY2";
  final String EXCLUDED2 = "EXCLUDED2";
  List<File> _allFiles = new List<File>();

  static Database _instance;

  Database._() {
    var containersToBuild = [SUMMARY, STANDBY, EXCLUDED, SUMMARY2, STANDBY2, EXCLUDED2];
    var leng = ((containersToBuild.length) / 2).round();
    for (int i = 0; i < leng; i++) {
      containers[containersToBuild.elementAt(i)] = new Container(containersToBuild.elementAt(i), 
          containersToBuild.elementAt(i + leng));
    }
  }

  static Database get() {
    if (_instance == null) {
      _instance = new Database._();
    }
    return _instance;
  }

  /*
   * 
   */
  Photo find(String id) {
    var aux;
    var photo;
    containers.forEach((_, c) {
      aux = c.find(id);
      if (aux != null) {
        photo = aux;
      }
    });
    return photo;
  }

  /*
   * 
   */
  Container findContainer(String photoID) {
    var _container;
    var aux;
    containers.forEach((_, container) {
      aux = container.find(photoID);
      if (aux != null) {
        _container = container;
      }
    });
    return _container;
  }

  List<File> get giveMeAllFiles => _allFiles;
  void addFilesToList(List<File> filesToAdd) => _allFiles.addAll(filesToAdd);

  List<File> giveMeAllSummaryFiles() {
    var size = _allFiles.length,
        listToReturn = new List<File>(),
        summaryContainer = containers[SUMMARY];
    for (int i = 0; i < size; i++) {
      if (summaryContainer.containerHasThatName(_allFiles.elementAt(i).name)) {
        listToReturn.add(_allFiles.elementAt(i));
      }
    }

    return listToReturn;
  }

  Photo get photoToDisplayPlease => photoToDisplay;
  Photo setPhotoToDisplay(String id) => photoToDisplay = find(id);

  double extractExifInformation(Photo photo) => _exifManager.extractExifInformation(photo);

  /**
   *  Used when Photos are beeing uploaded. We need to normalize data
   *  information so we can sort all photos directly in the same screen
   */
  double firstNormalization(DateTime date) => _exifManager.firstNormalization(date);

  /**
   * Used when all photos are uploaded and the user informs to start the summary build.
   * All integer that represents DateTime are now normalized between 0 and 1.
   */
  void secondNormalization() => _exifManager.secondNormalization(container(STANDBY).photos);

  /**
   * Add a new element to the database
   */
  void addNewElementsToDataBase(List<Photo> photos) {
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

  /*
   * 
   */
  Container container(String name) => containers[name];

  /**
   * Add to container
   */
  void moveFromTo(String origin, String destination, Iterable<Photo> photos) {
    photos.forEach((p) {
      container(origin).photos.remove(p);
      container(origin).photosToDisplay.remove(p);
      container(destination).photos.add(p);
      container(destination).photosToDisplay.add(p);
    });

    sortPhotos(container(origin).photos);
    sortPhotos(container(origin).photosToDisplay);
    container(origin).sortEverything();
    sortPhotos(container(destination).photos);
    sortPhotos(container(destination).photosToDisplay);
    container(destination).sortEverything();
  }

  /**
   * Clean Database data
   */
  bool cleanAllData() {
    var result = true;

    containers.forEach((containerName, container) {
      container.clearData();
    });
    photoToDisplay = null;

    return result;
  }

  /**
   * Build Summary
   */
  Future buildSummary(List<Photo> photos, int numberOfPhotosDefined) {
    var completer = new Completer();
    addNewElementsToDataBase(photos);
    var function = decideAlgorithm(numberOfPhotosDefined);
    
    completer.complete(function);
    return completer.future;
  }

  /**
   * Decide which algorithm to use in the summary creation
   */
  decideAlgorithm(int numberOfPhotos) {
    var function = _settings.whichAlgorithmInUse();
    extractCategories();
    switch (function) {
      case (Function.FunctionChoosed.FIRSTX):
        workFirstXSummary(numberOfPhotos);
        break;
      case (Function.FunctionChoosed.RANDOM):
        buildRandomSummary(numberOfPhotos);
        break;
      case (Function.FunctionChoosed.HIERARCHICAL):
        buildClusterSummary(numberOfPhotos);
        break;
      default:
        break;
    }

    secondExtractions();
  }

  /**
   *  Categories extraction
   */
  void extractCategories() {
    _categoryManager.categoriesPipeline(container(STANDBY).photos);
  }

  /*
   * 
   */
  void secondExtractions() {
    var container = containers.values.elementAt(0);
    container.facesListGroupOfPhotos.addAll(faces.FacesCategory.get().workFacesGroups(container.photos));
    container.dayMomentListGroupOfPhotos.addAll(dayMoment.DayMomentCategory.get().workDayMomentGroups(container.photos));
    container.colorListGroupOfPhotos.addAll(color.ToningCategory.get().workToningGroups(container.photos));
    container.qualityListGroupOfPhotos.addAll(quality.QualityCategory.get().workQualityGroups(container.photos));
    container.similarListGroupOfPhotos.addAll(similar.SimilarCategory.get().workSimilarCase(container.photos));
    sortPhotos(container.photos);
    container.sortEverything();

    container = containers.values.elementAt(1);
    container.facesListGroupOfPhotos.addAll(faces.FacesCategory.get().workFacesGroups(container.photos));
    container.dayMomentListGroupOfPhotos.addAll(dayMoment.DayMomentCategory.get().workDayMomentGroups(container.photos));
    container.colorListGroupOfPhotos.addAll(color.ToningCategory.get().workToningGroups(container.photos));
    container.qualityListGroupOfPhotos.addAll(quality.QualityCategory.get().workQualityGroups(container.photos));
    container.similarListGroupOfPhotos.addAll(similar.SimilarCategory.get().workSimilarCase(container.photos));
    sortPhotos(container.photos);
    container.sortEverything();

    container = containers.values.elementAt(2);
    container.facesListGroupOfPhotos.addAll(faces.FacesCategory.get().workFacesGroups(container.photos));
    container.dayMomentListGroupOfPhotos.addAll(dayMoment.DayMomentCategory.get().workDayMomentGroups(container.photos));
    container.colorListGroupOfPhotos.addAll(color.ToningCategory.get().workToningGroups(container.photos));
    container.qualityListGroupOfPhotos.addAll(quality.QualityCategory.get().workQualityGroups(container.photos));
    container.similarListGroupOfPhotos.addAll(similar.SimilarCategory.get().workSimilarCase(container.photos));
    sortPhotos(container.photos);
    container.sortEverything();
  }

  /**
   * First X photos
   */
  void workFirstXSummary(int numberOfPhotos) {
    var photos = container(STANDBY).photos.take(numberOfPhotos).toList();
    moveFromTo(STANDBY, SUMMARY, photos);
  }

  /**
   * For random tests
   */
  void buildRandomSummary(int numberOfPhotos) {
    var rnd = new Math.Random(),
        max = container(STANDBY).photos.length,
        photo;
    for (int i = 0; i < numberOfPhotos; i++) {
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
  void buildClusterSummary(int numberOfPhotos) {
    secondNormalization();
    print("CLUSTERING");
    var containerPhotos = container(STANDBY).photos;
    var summaryPhotos = _clusteringManager.doClustering(containerPhotos, numberOfPhotos, containerPhotos.length);
    print("ACABEI O CLUSTERING");
    moveFromTo(STANDBY, SUMMARY, summaryPhotos);

    printContainersState(); //TODO
  }

  /**
   *  Method to sort Photos
   */
  List<Photo> sortPhotos(List<Photo> photos) {
    var aux = photos;
    aux.sort();
    return aux;
  }

  /**
   *
   */
  void printContainersState() {
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

}