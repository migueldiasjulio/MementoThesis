library index;

import 'dart:html';
import 'mementoSettings.dart';
export "package:polymer/init.dart";
import 'dart:core';

class Index {
  
  static Index _instance;
  MementoSettings settings = MementoSettings.get();

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
    
    print("ALL DEFINED"); 
  }

  /**
   * Return a reference for the MementoSettings Singleton instance
   */ 
  static Index get() {
    if (_instance == null) {
      _instance = new Index._();
    }
    return _instance;
  }
  
  void defineFirstX(){
   //TODO
    print("Defining first X algorithm");
  }
  
  void defineRandom(){
    //TODO
    print("Defining random algorithm");
  }
  
  void defineHierarchical(){
    //TODO
    print("Defining hierachical algorithm");
  }
}
