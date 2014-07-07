library summaryDone;

import 'dart:html';
import 'dart:core';
import 'package:polymer/polymer.dart';
import 'package:route_hierarchical/client.dart';
import 'package:bootjack/bootjack.dart';
import '../../core/screenModule.dart' as screenhelper;
import '../../core/database/dataBase.dart';
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
  Element _summaryContainer;
  
  /**
   * Building Summary Done
   */
  SummaryDone.created() : super.created(){
    Modal.use();
    Transition.use();
    exportMenu = Modal.wire($['exportMenu']);
    _summaryContainer = $['t-SUMMARY'];
  }

  void runStartStuff() {
    checkSummaryContainer();
    cleanAll();
  }
  
  /**
   * On enter view
   */
  @override
  void enteredView() {
    super.enteredView();
    cleanAll();
  }
  
  void checkSummaryContainer(){
    _summaryContainer.setAttribute("checked", "checked");
    print(_summaryContainer.attributes.keys);
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
    List<String> names = new List<String>();
    
    this.summaryContainer.photos.forEach((thumbnail){
      names.add(thumbnail.title);
    });
    
    List test = new List();
    test.addAll(names);

    Blob blob = new Blob(test, 'text/plain', 'native');
    String url = Url.createObjectUrlFromBlob(blob);
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
    var id = target.attributes["data-id"];
    var isSelected;
    if(!selection){
      print("ID: " + id.toString());
      displayPhoto(id);
    }
    else{
      if(target.classes.contains('selected')){
              target.classes.remove('selected');
              isSelected = "false";
              removeFromSelectedPhotos(id);
              removeFromSelectedElements(target);
              print("$id is selected? $isSelected");
      }
      else{
        target.classes.add('selected');
        isSelected = "true";
        addToSelectedPhotos(id);
        addToSelectedElements(target);
        print("$id is selected? $isSelected");
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
        enter: (e) { 
          checkSummaryContainer();
        });
   }

  /*
   * Home
   */
  home(_) {}

  /*
   * Go Big Size Photo Screen
   */
  void displayPhoto(String id){
    router.go("big-size-photo.show", {id: id});
  }
}