library bigSize;

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:route_hierarchical/client.dart';
import '../../core/screenModule.dart' as screenhelper;
import '../../core/photo.dart';
import '../../core/dataBase.dart';
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

  @observable bool moving = false;

  BigSizePhoto.created() : super.created();

  /**
   * TODO
   */
  @override
   void setupRoutes(Route route) {
    route.addRoute(
        name: 'show',
        path: '/:id',
        enter: (e) {
          photo = DB.find(e.parameters['id']);
        }
    );
   }

  /*
   * TODO
   */
  @override
  void enteredView() {
    super.enteredView();
  }

  /*
   * TODO
   */
  void runStartStuff() {
    cleanVariables();
  }

  /*
   * TODO
   */
  home(_) {}


  /*
   * TODO
   */
  void returnToSummary(){
    router.go("summary-done", {});
  }

  /*
   *
   */
  void cancel(){
    selection=false;
    moving=false;
  }

  /*
   *
   */
  void showImage(Event event, var detail, Element target){
    var id = target.dataset["id"];
    var isSelected;
    if(!this.selection){
      print(target.attributes['data-incby']);
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

  void cancelMoveAction(){
    disableSelection();
    this.moving = false;
  }

  void enableMoveAction() {
    this.moving = true;
  }

  void showSummaryPhotos(){
    this.thumbnailsToShow.clear();
    this.thumbnailsToShow.addAll(this.thumbnailsSummary);
  }

  void showStandByPhotos(){
    this.thumbnailsToShow.clear();
    this.thumbnailsToShow.addAll(this.thumbnailsStandBy);
  }

  void showExcludedPhotos(){
    this.thumbnailsToShow.clear();
    this.thumbnailsToShow.addAll(this.thumbnailsExcluded);
  }

  void specialMoveToSummary(){
    this.moveToSummary();
    cancelMoveAction();
  }

  void specialMoveToStandBy(){
    this.moveToStandBy();
    cancelMoveAction();
  }

  void specialMoveToExcluded(){
    this.moveToExcluded();
    cancelMoveAction();
  }


}