library figurecaption;

import 'package:polymer/polymer.dart';
import 'dart:core';
import 'dart:html';
export "package:polymer/init.dart";
import 'package:bootjack/bootjack.dart';
export 'package:route_hierarchical/client.dart';
import '../../../core/photo/photo.dart';

/*
 * 
 */ 
@CustomTag('figure-caption-element')
class FigureCaptionElement extends PolymerElement {
  
  /*
   * 
   */ 
  @published Photo photo;
  @published int size;

  
  /*
   * 
   */ 
  FigureCaptionElement.created() : super.created(){

  }
    
}