library firstauxfunctions;

import 'dart:html';
import 'package:observe/observe.dart';

class FirstAuxFunctions extends Object with Observable{
  
  static FirstAuxFunctions _instance; 
  List<Element> elementsImported = new List<Element>();
  @observable bool changed = false;

  FirstAuxFunctions._(); 
  
  static FirstAuxFunctions get() {
    if (_instance == null) {
      _instance = new FirstAuxFunctions._();
    }
    return _instance;
  }
  
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
  
  void toogleToOff(Element element){
    element.classes.remove('showThis');
    element.classes.add('hideThis');
  }
  
  void toogleToOn(Element element){
    element.classes.remove('hideThis');
    element.classes.add('showThis');
  }
  
}