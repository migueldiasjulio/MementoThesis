library algorithmOptions;

import 'package:polymer/polymer.dart';
import 'package:route_hierarchical/client.dart';
export 'package:route_hierarchical/client.dart';
import 'dart:html';
import 'dart:core';
import 'package:bootjack/bootjack.dart';
import '../../core/settings/mementoSettings.dart';

abstract class AlgorithmOptions extends PolymerElement {
  
  // This lets the CSS "bleed through" into the Shadow DOM of this element.
  bool get applyAuthorStyles => true;
  bool get preventDispose => true;
  
  MementoSettings _settings = MementoSettings.get();
  
  AlgorithmOptions.created() : super.created(){
    //TODO
  }
  
  void defineFirstX(){
    print("First X");
    _settings.setFunction("FIRSTX");
  }
  
  void defineRandom(){
    print("Random");
    _settings.setFunction("RANDOM");
  }
  
  void defineHierarchical(){
    print("Hierachical");
    _settings.setFunction("HIERARCHICAL");
  }
  
}