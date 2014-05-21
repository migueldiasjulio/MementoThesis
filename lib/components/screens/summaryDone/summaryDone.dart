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
    exportToHardDrive();
  }
  
  void exportToHardDrive(){
    List<Thumbnail> thumbToExport = this.thumbnailsSummary;
    List<ImageElement> imgs = new List<ImageElement>();
    
    List<File> filesToExport = new List<File>();
    List<String> names = new List<String>();
    
    ImageElement img = new ImageElement();
    for(Thumbnail thumb in thumbToExport){
      img.setAttribute("src", thumb.src);
      imgs.add(img);
      //names.add(thumb.title);
    }
    List test = new List();
    test.addAll(names);
    List body = [ 'This list is the text\n',
                   'which our final output\n',
                   'file will contain.\n\n',
                   "It's really nothing\n",
                   'special in any way.\n',
                   'Normally this stuff would\n',
                   'be dynamically generated\n',
                   'in some way.\n\n'];
    
    // Create a new blob from the data.
    Blob blob = new Blob(test, 'text/plain', 'native');
    // Create a data:url which points to that data.
    String url = Url.createObjectUrlFromBlob(blob);
    // Create a link to navigate to that data and download it.
    AnchorElement link = new AnchorElement()
        ..href = url
        ..download = 'Memento.txt'
        ..text = 'My Device';
    
    // Insert the link into the DOM.
    var myDevice = $['myDeviceDownload'];
    myDevice.append(link);
    
  }
  
  void exportToFacebook(){
    
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

    void showImage(String thumbName){
      print(thumbName);
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