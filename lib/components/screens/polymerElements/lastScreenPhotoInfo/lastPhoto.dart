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
  // This lets the CSS "bleed through" into the Shadow DOM of this element.
  bool get applyAuthorStyles => true;
  bool get preventDispose => true;
  
  @published Photo photo;
  
  photoChanged(){
    print("Changed!");
    photo = photo;
  }

  /*
   * 
   */ 
  LastPhotoElement.created() : super.created(){

  }
    
}