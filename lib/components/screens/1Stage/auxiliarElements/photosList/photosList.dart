library photosList;

import 'package:polymer/polymer.dart';
import 'dart:core';
export "package:polymer/init.dart";
import 'package:bootjack/bootjack.dart';
export 'package:route_hierarchical/client.dart';
import '../../../../core/photo/photo.dart';
import 'dart:html';
import 'package:observe/observe.dart';
import '../../auxiliarFunctions/firstAuxFunctions.dart';
import 'dart:js' as js show JsObject, context;

final _firstAuxFunctions = FirstAuxFunctions.get();

/*
 * 
 */ 
@CustomTag('photos-list')
class PhotosList extends PolymerElement {

  /*
   * 
   */ 
  @published ObservableList<Photo> photosToShow = toObservable([]);
  @published bool modifiedVariable = false;
  //List<Photo> photosAlreadyWithElement = new List<Photo>();
  
  /*
   * 
   */ 
  PhotosList.created() : super.created(){}
  
  /*
   * 
   */ 
  void modifiedVariableChanged(){
    print("CHANGED!");
    saveImportedElements();
    _firstAuxFunctions.organizeAndDisplayData(modifiedVariable);
  }
  
  /*
   * 
   */ 
  void testJS(){
    var exif = new js.JsObject(js.context['EXIF'], []); 
    var photo = $['photo_1'];
    var exifWorking = exif.callMethod('loadAllImages',[]);
    print(exifWorking.toString()); 
  }
 
  /*
   * 
   */ 
  void showMoreInfo(Event event, var detail, Element target){
    //testJS();
    var children = target.children,
        figcaption = children[1];
    
    _firstAuxFunctions.toogleFigCaption(figcaption); 
  }
  
  /*
   * 
   */ 
  void saveImportedElements(){ 
    var element,
        allImportedPhotos = new List<Element>(),
        thisID,
        elementParent,
        elementToAdd;
    
    photosToShow.forEach((photo){
      thisID = photo.id;
      element = $[thisID];
      elementParent = element.parent;
      elementToAdd = elementParent.children[1];

      allImportedPhotos.add(elementToAdd);
    });
    
    _firstAuxFunctions.elementsImported.clear();  
    _firstAuxFunctions.elementsImported.addAll(allImportedPhotos);  
  }
}