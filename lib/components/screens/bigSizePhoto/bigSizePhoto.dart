library bigSize;

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:route_hierarchical/client.dart';
import '../../core/screenModule.dart' as screenhelper;
import '../../core/photo/photo.dart';
import '../../core/database/dataBase.dart';
export "package:polymer/init.dart";

/**
 * BigSizePhoto Screen 
 */
@CustomTag(BigSizePhoto.TAG)
class BigSizePhoto extends screenhelper.SpecialScreen {
  
  static const String TAG = "big-size-photo";
  String title = "Big Size Photo",
         description = "Photo big size";
  factory BigSizePhoto() => new Element.tag(TAG);
  Element _name;

  @observable Photo photo;

  final List<Photo> photos = toObservable([]);
  Element _summaryContainer;
  Element _standByContainer;
  Element _excludedContainer;

  BigSizePhoto.created() : super.created(){
    _summaryContainer = $['t-SUMMARY'];
    _standByContainer = $['t-STANDBY'];
    _excludedContainer = $['t-EXCLUDED'];
  }

  /**
   * TODO
   */
  @override
   void setupRoutes(Route route) {
    route.addRoute(
        name: 'show',
        path: '/:id',
        enter: (e) {
          print("Estou a vir aqui!");
          print(e.parameters['id']);
          photo = DB.find(e.parameters['id']);
          currentContainer = DB.findContainer(photo.id);
          setContainer();
        }
    );
   }
  /*
   * TODO
   */
  @override
  void enteredView() {
    super.enteredView();
    setContainer();
  }
  
  /*
   * TODO
   */ 
  void runStartStuff() {
    cleanAll();
  }
  
  void setContainer(){
    switch(currentContainer.name){
      case(SUMMARY): 
        _summaryContainer.setAttribute("checked","checked");
        break;
      case(STANDBY): 
        _standByContainer.setAttribute("checked","checked");
        break;
      case(EXCLUDED): 
        _excludedContainer.setAttribute("checked","checked");
        break;
      default:
        break;
    }
  }
  
  /*
   * 
   */

  /*
   * TODO
   */
  home(_) {}

  /*
   * TODO
   */
  void returnToSummary(){
    disableSelection();
    router.go("summary-done", {});
  }

  /*
   *
   */
  void cancel(){
    selection=false;
  }
  
  /*
   *
   */
  void showImage(Event event, var detail, Element target){
    var id = target.dataset["data-id"];
    var isSelected;
    if(!this.selection){
      print(target.attributes['data-incby']);
      this.photo = DB.find(target.attributes['data-id']);
    } else{
      if(target.classes.contains('selected')){
        target.classes.remove('selected');
        removeFromSelectedPhotos(id);
        removeFromSelectedElements(target);
        print("$id is selected? $isSelected");
      } else{
        target.classes.add('selected');
        addToSelectedPhotos(id);
        addToSelectedElements(target);
        print("$id is selected? $isSelected");
      }
    }
  }  
}