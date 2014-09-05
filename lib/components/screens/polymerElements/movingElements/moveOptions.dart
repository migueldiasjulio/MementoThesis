library moveoptions;

import 'package:polymer/polymer.dart';
import 'dart:core';
export "package:polymer/init.dart";
export 'package:route_hierarchical/client.dart';
import '../../../core/database/dataBase.dart';
/*
 * 
 */ 
typedef void moveToContainer(event, detail, target);

@CustomTag('move-options')
class MoveOptions extends PolymerElement {
  
  @published moveToContainer moveToContainerFunction;
  @published Container currentContainer;
  @published Container summaryContainer;
  @published Container standbyContainer; 
  @published Container excludedContainer;
  
  /*
   * 
   */ 
  MoveOptions.created() : super.created(){
   
  }
  
  void moveToContainerPlease(event, detail, target) => moveToContainerFunction(event, detail, target);
  
}