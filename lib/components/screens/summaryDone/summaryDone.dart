library summaryDone;

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:route_hierarchical/client.dart';
import '../../core/screenModule.dart' as screenhelper;
import '../../core/dataBase.dart';
import '../../core/Thumbnail.dart';

/**
 * TODO
 */
@CustomTag(SummaryDone.TAG)
class SummaryDone extends screenhelper.Screen {

  /**
   * TODO
   */
  static const String TAG = "summary-done";
  String title = "Summary Done",
         description = "Summary results";
  @observable Selection selection = null;
  factory SummaryDone() => new Element.tag(TAG);
  final List<Thumbnail> thumbnailsSummary = toObservable([]);
  final List<Thumbnail> thumbnailsStandBy = toObservable([]);
  final List<Thumbnail> thumbnailsExcluded = toObservable([]);

  @override
  void enteredView() {
    super.enteredView();
    syncSummaryPhotos();
    syncStandByPhotos();
    syncExcludedPhotos();
  }

  /**
   * TODO
   */
  SummaryDone.created() : super.created(){

  }

  void syncSummaryPhotos(){
    thumbnailsSummary.clear();
    thumbnailsSummary.addAll(this.myDataBase.giveContainerPhotos("SUMMARY"));
    $['summaryNumber'].contentEditable = thumbnailsSummary.length.toString();
  }

  void syncStandByPhotos(){
    thumbnailsStandBy.clear();
    thumbnailsStandBy.addAll(this.myDataBase.giveContainerPhotos("STANDBY"));
    $['standByNumber'].contentEditable = thumbnailsSummary.length.toString();
  }

  void syncExcludedPhotos(){
    thumbnailsExcluded.clear();
    thumbnailsExcluded.addAll(this.myDataBase.giveContainerPhotos("EXCLUDED"));
    $['excludedNumber'].contentEditable = thumbnailsSummary.length.toString();
  }

  void showImage(){
    print("SHOW");
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

  /**
   * TODO
   */
  home(_) {}

}