library summaryDone;

import 'dart:html';
import 'dart:core';
import 'package:polymer/polymer.dart';
import 'package:route_hierarchical/client.dart';
import 'package:bootjack/bootjack.dart';
import '../../core/ScreenModule.dart' as screenhelper;
import '../../core/DataBase.dart';
import '../../core/Thumbnail.dart';

/**
 * TODO
 */
@CustomTag(SummaryDone.TAG)
class SummaryDone extends screenhelper.Screen {

  /**
   * Variables
   */
  static const String TAG = "summary-done";
  String title = "Summary Done",
         description = "Summary results";
  @observable bool selection = false;
  @observable bool export = false;
  Modal exportMenu;
  factory SummaryDone() => new Element.tag(TAG);
  final List<Thumbnail> thumbnailsSummary = toObservable([]);
  final List<Thumbnail> thumbnailsStandBy = toObservable([]);
  final List<Thumbnail> thumbnailsExcluded = toObservable([]);

  /**
   * On enter view
   */
  @override
  void enteredView() {
    super.enteredView();
    //syncSummaryPhotos();
    //syncStandByPhotos();
    //syncExcludedPhotos();
  }

  /**
   * Building Summary Done
   */
  SummaryDone.created() : super.created(){
    Modal.use();
    Transition.use();
    exportMenu = Modal.wire($['exportMenu']);
  }
  
  void runStartStuff() {
    syncSummaryPhotos();
    syncStandByPhotos();
    syncExcludedPhotos();
    print(this.thumbnailsSummary.length.toString());
    print(this.thumbnailsStandBy.length.toString());
    print(this.thumbnailsExcluded.length.toString());
    
  }
  
  void enableSelection(){
    this.selection = true;
  }
  
  void disableSelection(){
    this.selection = false;
  }
  
  void enableExport(){
    this.export = true;
  }
  
  void disableExport(){
    this.export = false;
  }
  
  void exportSummary(){
    this.exportMenu.show();
  }
  
  void exportToHardDrive(){
    
  }
  
  void exportToFacebook(){
    
  }

  void syncSummaryPhotos(){
    thumbnailsSummary.clear();
    thumbnailsSummary.addAll(this.myDataBase.giveContainerPhotos("SUMMARY"));
    //$['summaryNumber'].contentEditable = thumbnailsSummary.length.toString();
  }

  void syncStandByPhotos(){
    thumbnailsStandBy.clear();
    thumbnailsStandBy.addAll(this.myDataBase.giveContainerPhotos("STANDBY"));
    //$['standByNumber'].contentEditable = thumbnailsSummary.length.toString();
  }

  void syncExcludedPhotos(){
    thumbnailsExcluded.clear();
    thumbnailsExcluded.addAll(this.myDataBase.giveContainerPhotos("EXCLUDED"));
    //$['excludedNumber'].contentEditable = thumbnailsSummary.length.toString();
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