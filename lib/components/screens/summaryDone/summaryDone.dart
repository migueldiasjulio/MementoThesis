library summaryDone;

import 'dart:html';
import 'dart:core';
import 'package:polymer/polymer.dart';
import 'package:route_hierarchical/client.dart';
import 'package:bootjack/bootjack.dart';
import '../../core/screenModule.dart' as screenhelper;
import '../../core/MementoImage.dart';
export "package:polymer/init.dart";


/**
 * Summary Done Screen
 */
@CustomTag(SummaryDone.TAG)
class SummaryDone extends screenhelper.SpecialScreen {

  /**
   * Variables
   */
  static const String TAG = "summary-done";
  String title = "Summary Done",
         description = "Summary results";
  Modal exportMenu;
  @observable bool export = false;
  factory SummaryDone() => new Element.tag(TAG);
  
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
    cleanVariables();
  }
  
  /**
   * On enter view
   */
  @override
  void enteredView() {
    super.enteredView();
    cleanVariables();
    printVariableStante();
  }
   
  /**
   * Export Functions
   */
  
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
    List<MementoImage> thumbToExport = this.thumbnailsSummary;
    List<ImageElement> imgs = new List<ImageElement>();

    List<File> filesToExport = new List<File>();
    List<String> names = new List<String>();

    ImageElement img = new ImageElement();
    for(MementoImage thumb in thumbToExport){
      img.setAttribute("src", thumb.imageSrc);
      imgs.add(img);
      names.add(thumb.imageTitle + "\r\n");
    }
    List test = new List();
    test.addAll(names);

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

  void exportToFacebook(){}
  
  /**
   * Export Functions
   */

  /*
   *  Show image
   */ 
  void showImage(Event event, var detail, var target){
    var nameOfPhoto;
    var isSelected;
    if(!this.selection){
      print(target.attributes['data-incby']);
      this.myDataBase.setImageToBeDisplayed(target.attributes['data-incby']);
      displayPhoto();
    }
    else{
      nameOfPhoto = target.attributes['data-incby'];
      isSelected = target.attributes['selected'];
      if(isSelected == "true"){
        target.attributes['selected'] = "false";
        removeFromSelectedPhotos(nameOfPhoto);
        removeFromSelectedElements(target);
        print(nameOfPhoto + " is selected? " + isSelected);
      }
      else{
        target.attributes['selected'] = "true";
        addToSelectedPhotos(nameOfPhoto);
        addToSelectedElements(target);
        print(nameOfPhoto + " is selected? " + isSelected);
      }
    }
  }

  /*
   * Setup Routes
   */
  @override
   void setupRoutes(Route route) {
    route.addRoute(
        name: 'home',
        path: '',
        enter: home);
   }

  /*
   * Home
   */
  home(_) {}

  /*
   * Go Big Size Photo Screen
   */ 
  void displayPhoto(){
    router.go("big-size-photo", {});
  }
}