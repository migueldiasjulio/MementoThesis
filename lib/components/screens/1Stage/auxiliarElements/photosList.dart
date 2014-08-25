library photosList;

import 'package:polymer/polymer.dart';
import 'dart:core';
export "package:polymer/init.dart";
import 'package:bootjack/bootjack.dart';
export 'package:route_hierarchical/client.dart';
import '../../../core/photo/photo.dart';
import 'dart:html';
import 'package:observe/observe.dart';
import '../firstAuxFunctions.dart';

final _firstAuxFunctions = FirstAuxFunctions.get();

@CustomTag('photos-list')
class PhotosList extends PolymerElement {

  @published ObservableList<Photo> photosToShow = toObservable([]);
  @published bool modifiedVariable = false;
  List<Photo> photosAlreadyWithElement = new List<Photo>();
  
  PhotosList.created() : super.created(){}
  
  void modifiedVariableChanged(){
    saveImportedElements(photosToShow);
  }
  
  void showMoreInfo(Event event, var detail, Element target){
    var children = target.children,
        figcaption = children[1];
    
    _firstAuxFunctions.toogleFigCaption(figcaption); 
  }
  
  void saveImportedElements(List<Photo> importedPhotos){
    var listAux = importedPhotos;
    listAux = listAux.skip(photosAlreadyWithElement.length);
    photosAlreadyWithElement.addAll(listAux);
    
    var element,
        allImportedPhotos = new List<Element>(),
        thisID,
        elementParent,
        elementToAdd;
    
    listAux.forEach((photo){
      thisID = photo.id;
      element = $[thisID];
      print("Element: " + element.toString());
      elementParent = element.parent;
      elementToAdd = elementParent.children[1];

      allImportedPhotos.add(elementToAdd);
    });
    
    _firstAuxFunctions.elementsImported.addAll(allImportedPhotos);  
  }
}