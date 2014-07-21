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
      _instance = new Index._();
    }
    return _instance;
  }
  
  void defineFirstX(){
    _settings.setFunction("FIRSTX");
  }
  
  void defineRandom(){
    _settings.setFunction("RANDOM");
  }
  
  void defineHierarchical(){
    _settings.setFunction("HIERARCHICAL");
  }
}
