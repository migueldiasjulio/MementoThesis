library database;

import 'photo.dart';
import 'dart:math' as Math;
import 'mementoSettings.dart';
import 'FunctionChoosed.dart' as Function;

import 'package:observe/observe.dart';

const String SUMMARY = "SUMMARY";
const String STANDBY = "STANDBY";
const String EXCLUDED = "EXCLUDED";

final DB = Database.get();

class Container extends Object with Observable {
  final String name;
  final List<Photo> photos = toObservable(new Set());
  Container(this.name);
  Photo find(String id) => photos.firstWhere((p) => p.id == id, orElse: () => null);
}

class Database extends Object with Observable {

  MementoSettings _settings = MementoSettings.get();

  final Map<String, Container> containers = toObservable({});

  int _version = 1;

  /**
   * Singleton
   */
  static Database _instance;

  Database._() {
    [SUMMARY, STANDBY, EXCLUDED].forEach((k) {
      containers[k] = new Container(k);
    });
  }

  static Database get() {
    if (_instance == null) {
      _instance = new Database._();
    }
    return _instance;
  }

  /**
   *
   */
  int get version => _version;

  /**
   *
   */
  void _incVersion(){
    _version++;
  }

  Photo find(String id) {
    var photo;
    containers.forEach((_, c) {
      photo  = c.find(id);
    });
    return photo;
  }


  /**
   * Add a new element to the database
   */
  void addNewElementsToDataBase(List<Photo> photos){
    _incVersion();
    //Adding all photos to stand-by container
    container(STANDBY).photos.addAll(photos);
  }

  /**
   * Add to container
   */
  void addToContainer(String name, List<Photo> photos) {
    container(name)
    .photos.addAll(photos);
    printContainersState(); //TODO
  }

  Container container(String name) => containers[name];

  /**
   * Add to container
   */
  void moveFromTo(String origin, String destination , Iterable<Photo> photos){
    photos.forEach((p) {
      container(origin).photos.remove(p);
      container(destination).photos.add(p);
    });
    printContainersState(); //TODO
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
    var photos = container(STANDBY).photos.take(numberOfPhotos).toList();
    moveFromTo(STANDBY, SUMMARY, photos);
  }

  /**
   * For random tests
   */
  void buildRandomSummary(int numberOfPhotos){
    var rnd = new Math.Random(),
        max = container(STANDBY).photos.length;

    var photo;
    for(int i = 0; i < numberOfPhotos; i++){
      photo = container(STANDBY).photos.elementAt( rnd.nextInt(max));
      container(SUMMARY).photos.add(photo);
      container(STANDBY).photos.remove(photo);
    }
    printContainersState(); //TODO
  }

  /**
   * With cluster algorithm
   */
  void buildClusterSummary(int numberOfPhotos){


    ///start algorithm










    this.printContainersState(); //TODO
  }


  /**
   *
   *
   *
   * TEST FUNCTIONS
   *
   *
   */

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