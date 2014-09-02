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
  
  void checkTheRightAlgorithm(){
    cleanAllElements();
    var functionRightNow = _settings.whichAlgorithmInUse(),
        functionName = functionRightNow.toString();
    if(functionName == "FunctionCoosed.FIRSTX"){
      var element = $['firstx'];
      element.setAttribute("checked", "checked");
    }
    if(functionName == "FunctionCoosed.RANDOM"){
      var element = $['random'];
      element.setAttribute("checked", "checked");
    }
    if(functionName == "FunctionCoosed.HIERARCHICAL"){
      var element = $['hierachical'];
      element.setAttribute("checked", "checked");
    }
  }
  
  void cleanAllElements(){
    var element =  $['firstx'];
    element.attributes.remove("checked");
    element = $['random'];
    element.attributes.remove("checked");
    element = $['hierachical'];
    element.attributes.remove("checked");
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