library firstauxfunctions;

import 'dart:html';
import 'package:observe/observe.dart';
import 'dart:isolate';
import 'dart:html';
import 'package:observe/observe.dart';
import '../../../core/photo/photo.dart';

class FirstAuxFunctions extends Object with Observable{
  
  /*
   * 
   */ 
  static FirstAuxFunctions _instance; 
  List<Element> elementsImported = new List<Element>();
  @observable bool changed = false;
  SendPort sendPort = null;
  List<Photo> photos = null;
  int numberDefinedInt = null;
  FirstAuxFunctions._(); 
  
  /*
   * 
   */ 
  static FirstAuxFunctions get() {
    if (_instance == null) {
      _instance = new FirstAuxFunctions._();
    }
    return _instance;
  }
  
  /**
   * Set all Isolate variables
   */
  void setIsolateVariables(SendPort port, List<Photo> listOfPhotos, int number){
    sendPort = port;
    photos = listOfPhotos;
    numberDefinedInt = number;
  }
  
  /*
   * 
   */ 
  //In common with top and above functions
  void toogleFigCaption(Element element){
    if(element.classes.contains('hideThis')){
      element.classes.remove('hideThis');
      element.classes.add('showThis');
    }else{
      element.classes.remove('showThis');
      element.classes.add('hideThis');
    }
  }
  
  /*
   * 
   */ 
  void toogleToOff(Element element){
    element.classes.remove('showThis');
    element.classes.add('hideThis');
  }
  
  /*
   * 
   */ 
  void toogleToOn(Element element){
    element.classes.remove('hideThis');
    element.classes.add('showThis');
  }
  
  /*
   * 
   */ 
  void organizeAndDisplayData(bool showingData){
    switch(showingData){
      case true: 
        elementsImported.forEach((displayedImage){
          toogleToOn(displayedImage);
        });
        break;
      case false : 
        elementsImported.forEach((displayedImage){
          toogleToOff(displayedImage);
        });
        break;
      default: break;
    }
  }
  
}