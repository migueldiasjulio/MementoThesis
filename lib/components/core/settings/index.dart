library index;

import 'dart:html';
import 'mementoSettings.dart';
export "package:polymer/init.dart";
import 'dart:core';

class Index {
  
  static Index _instance;
  MementoSettings _settings = MementoSettings.get();

  /**
   * Singleton
   */
  Index._(){
    querySelector("#firstx")
        ..onClick.listen((e) {
        defineFirstX();
        });
    querySelector("#random")
        ..onClick.listen((e) {
        defineRandom();
            });
    querySelector("#hierachical")
        ..onClick.listen((e) {
        defineHierarchical();
            });
  }

  /**
   * Return a reference for the MementoSettings Singleton instance
   */ 
  static Index get() {
    if (_instance == null) {
      print("Index instance created!");
      _instance = new Index._();
    }
    print("Got Index instance!");
    return _instance;
  }
  
  void defineFirstX(){
   //TODO
    print("Defining first X algorithm");
    _settings.setFunction("FIRSTX");
  }
  
  void defineRandom(){
    //TODO
    print("Defining random algorithm");
    _settings.setFunction("RANDOM");
  }
  
  void defineHierarchical(){
    //TODO
    print("Defining hierachical algorithm");
    _settings.setFunction("HIERARCHICAL");
  }
}
