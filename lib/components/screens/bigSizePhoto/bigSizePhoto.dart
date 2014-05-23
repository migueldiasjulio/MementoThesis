library bigSize;

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:route_hierarchical/client.dart';
import '../../core/screenModule.dart' as screenhelper;
import '../../core/Thumbnail.dart';

/**
 * TODO
 */
@CustomTag(BigSizePhoto.TAG)
class BigSizePhoto extends screenhelper.Screen {

  static const String TAG = "big-size-photo";
  String title = "Big Size Photo",
         description = "Photo big size";
  factory BigSizePhoto() => new Element.tag(TAG);
  Element _name;
  @published Thumbnail thumbToDisplay = null;
  final List<Thumbnail> thumbnailsSummary = toObservable([]);
  final List<Thumbnail> thumbnailsStandBy = toObservable([]);
  final List<Thumbnail> thumbnailsExcluded = toObservable([]);
  @observable bool selection = false;
  @observable bool moving = false;

  Thumbnail get thumbnailDisplay => thumbToDisplay;

  BigSizePhoto.created() : super.created();

  /**
   * TODO
   */
  @override
   void setupRoutes(Route route) {
    route.addRoute(
        name: 'home',
        path: '',
        enter: home);
   }

  /**
   * TODO
   */
  @override
  void enteredView() {
    super.enteredView();
    checkWhatPhotoToDisplay();
  }


  /**
   * TODO
   */
  home(_) {}

  /**
   *
   */
  void checkWhatPhotoToDisplay(){
    this.thumbToDisplay = this.myDataBase.returnImageToDisplay();
  }

  /**
   *
   */
  void returnToSummary(){
    router.go("summary-done", {});
  }

  /**
   *
   */
  void selectPhotos(){
    selection = true;
    //TODO
  }

  /**
   *
   */
  void cancel(){
    selection=false;
    moving=false;
  }

  /**
   *
   */
  void moveToFromBools(){
    moving = true;
  }

  /**
   *
   */
  //TODO This must go to a superclass. BigSizePhoto and summaryDone should extend from there
  void syncSummaryPhotos(){
    thumbnailsSummary.clear();
    thumbnailsSummary.addAll(this.myDataBase.getThumbnails("SUMMARY"));
  }

  /**
   *
   */
  void syncStandByPhotos(){
    thumbnailsStandBy.clear();
    thumbnailsStandBy.addAll(this.myDataBase.getThumbnails("STANDBY"));
  }

  /**
   *
   */
  void syncExcludedPhotos(){
    thumbnailsExcluded.clear();
    thumbnailsExcluded.addAll(this.myDataBase.getThumbnails("EXCLUDED"));
  }

  /**
   * When we already know the photo/photos new destination we change them localy to the page
   * and we inform the database about that changes
   * @param from
   * @param to
   * @param thumbs
   * @param origin
   * @param destination
   */
  void moveFunction(String from, String to,
      List<Thumbnail> thumbs, List<Thumbnail> origin, List<Thumbnail> destination){

    List<String> thumbNames = new List<String>();
    for(Thumbnail thumb in thumbs){
      origin.remove(thumb);
      destination.add(thumb);
      thumbNames.add(thumb.title);
    }
    this.myDataBase.moveFromTo(from, to, thumbNames);
  }

  /**
   * Function created to help the moving action of a photo from a "from" container
   * to a "to" container.
   * @param from - String
   * @param to - String
   * @param thumbnails - List<Thumbnail>
   */
  void moveFromTo(String from, String to, List<Thumbnail> thumbnails){
    switch(from){
         case("SUMMARY") :
           switch(to) {
             case("STANDBY") :
               moveFunction(from, to, thumbnails, this.thumbnailsSummary, this.thumbnailsStandBy);
               break;
             case("EXCLUDED") :
               moveFunction(from, to, thumbnails, this.thumbnailsSummary, this.thumbnailsExcluded);
               break;
           }
           break;
         case("STANDBY") :
           switch(to) {
             case("SUMMARY") :
               moveFunction(from, to, thumbnails, this.thumbnailsStandBy, this.thumbnailsSummary);
               break;
             case("EXCLUDED") :
               moveFunction(from, to, thumbnails, this.thumbnailsStandBy, this.thumbnailsExcluded);
               break;
           }
           break;
         case("EXCLUDED") :
           switch(to) {
             case("SUMMARY") :
               moveFunction(from, to, thumbnails, this.thumbnailsExcluded, this.thumbnailsSummary);
               break;
             case("STANDBY") :
               moveFunction(from, to, thumbnails, this.thumbnailsExcluded, this.thumbnailsStandBy);
               break;
           }
           break;
         default: break;
       }
  }
}