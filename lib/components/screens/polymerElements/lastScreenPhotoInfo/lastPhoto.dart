library lastphoto;

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
@CustomTag('last-photo-info-element')
class LastPhotoElement extends PolymerElement {
  
  /*
   * 
   */ 
  @published Photo photo;

  /*
   * 
   */ 
  LastPhotoElement.created() : super.created(){

  }
    
}