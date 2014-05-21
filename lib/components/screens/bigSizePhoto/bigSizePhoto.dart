library bigSize;

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:route_hierarchical/client.dart';
import '../../core/ScreenModule.dart' as screenhelper;
import '../../core/DataBase.dart';
import '../../core/Thumbnail.dart';
import '../../core/ContainerClass.dart' as container;

/**
 * TODO
 */
@CustomTag(BigSizePhoto.TAG)
class BigSizePhoto extends screenhelper.Screen {

  static const String TAG = "big-size-photo";
  String title = "Big Size Photo",
         description = "Photo big size";
  factory BigSizePhoto() => new Element.tag(TAG);
  String photoToDisplay;
  Element _name;
  @published Thumbnail thumbToDisplay = null;
  final List<Thumbnail> thumbnailsSummary = toObservable([]);
  final List<Thumbnail> thumbnailsStandBy = toObservable([]);
  final List<Thumbnail> thumbnailsExcluded = toObservable([]);
  
  Thumbnail get thumbnailDisplay => thumbToDisplay;
  
  BigSizePhoto.created() : super.created(){
    _name = $['name'];
  }
  
  

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
  
  void returnToSummary(){
    router.go("summary-done", {});
  }
  
  /**
   * TODO
   */
  @override
  void enteredView() {
    super.enteredView();
    checkWhatPhotoToDisplay();
  }

  void checkWhatPhotoToDisplay(){
    this.photoToDisplay = this.myDataBase.givephotoName;
  }
  
  //TODO This must go to a superclass. BigSizePhoto and summaryDone should extend from there
  void syncSummaryPhotos(){
    thumbnailsSummary.clear();
    thumbnailsSummary.addAll(this.myDataBase.getThumbnails("SUMMARY"));
  }

  void syncStandByPhotos(){
    thumbnailsStandBy.clear();
    thumbnailsStandBy.addAll(this.myDataBase.getThumbnails("STANDBY"));
  }

  void syncExcludedPhotos(){
    thumbnailsExcluded.clear();
    thumbnailsExcluded.addAll(this.myDataBase.getThumbnails("EXCLUDED"));
  }

  /**
   * TODO
   */
  home(_) {}
}