library summaryDone;

import 'dart:html';
import 'dart:core';
import 'package:polymer/polymer.dart';
import 'package:route_hierarchical/client.dart';
import 'package:bootjack/bootjack.dart';
import '../../core/screenModule.dart' as screenhelper;
import '../../core/Thumbnail.dart';
export "package:polymer/init.dart";


/**
 * TODO
 */
@CustomTag(SummaryDone.TAG)
class SummaryDone extends screenhelper.Screen with ChangeNotifier  {

  /**
   * Variables
   */
  static const String TAG = "summary-done";
  String title = "Summary Done",
         description = "Summary results";
  @reflectable @observable bool get selection => __$selection; bool __$selection = false; @reflectable set selection(bool value) { __$selection = notifyPropertyChange(#selection, __$selection, value); }
  @reflectable @observable bool get export => __$export; bool __$export = false; @reflectable set export(bool value) { __$export = notifyPropertyChange(#export, __$export, value); }

  @reflectable @observable bool get atSummary => __$atSummary; bool __$atSummary = false; @reflectable set atSummary(bool value) { __$atSummary = notifyPropertyChange(#atSummary, __$atSummary, value); }
  @reflectable @observable bool get atStandBy => __$atStandBy; bool __$atStandBy = false; @reflectable set atStandBy(bool value) { __$atStandBy = notifyPropertyChange(#atStandBy, __$atStandBy, value); }
  @reflectable @observable bool get atExcluded => __$atExcluded; bool __$atExcluded = false; @reflectable set atExcluded(bool value) { __$atExcluded = notifyPropertyChange(#atExcluded, __$atExcluded, value); }

  Modal exportMenu;
  factory SummaryDone() => new Element.tag(TAG);
  final List<Thumbnail> thumbnailsSummary = toObservable([]);
  final List<Thumbnail> thumbnailsStandBy = toObservable([]);
  final List<Thumbnail> thumbnailsExcluded = toObservable([]);
  final List<String> selectedPhotos = toObservable([]);
  final List<Element> selectedElements = toObservable([]);

  /**
   * On enter view
   */
  @override
  void enteredView() {
    super.enteredView();
    cleanVariables();
    //syncSummaryPhotos();
    //syncStandByPhotos();
    //syncExcludedPhotos();
  }

  void cleanVariables(){
    this.selectedPhotos.clear();
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
    cleanVariables();
  }

  void enableSelection(){
    this.selection = true;
  }

  void disableSelection(){
    this.selection = false;
    cleanSelection();
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
   * Return thumbnail with name as argument
   * We receive the origin container so we can know from where we gonna get the thumbnail
   * @param photoName - String
   * @return Thumbnail
   */
  Thumbnail returnThumbnail(String origin, String photoName){
    Thumbnail thumbReturn = null;
    switch(origin){
         case("SUMMARY") :            //NOOOOB change this later (for loop to search for thumbnail; change for Map)
               for(Thumbnail thumb in this.thumbnailsSummary){
                 if(thumb.title == photoName){
                   thumbReturn = thumb;
                   break;
                 }
               }
               break;
         case("STANDBY") :
           for(Thumbnail thumb in this.thumbnailsStandBy){
             if(thumb.title == photoName){
               thumbReturn = thumb;
               break;
             }
           }
           break;
         case("EXCLUDED") :
           for(Thumbnail thumb in this.thumbnailsExcluded){
             if(thumb.title == photoName){
               thumbReturn = thumb;
               break;
             }
           }
           break;
         default: break;
       }
    return thumbReturn;
  }

  /**
   * Move to Summary container
   */
  void moveToSummary(){
    movePhotosFunction("STANDBY", "SUMMARY"); //TODO Change this. Just testing.
    cleanAll();
    /*
    if(atSummary){
     //Nothing
      return;
    }
    if(atStandBy){
      movePhotosFunction("STANDBY", "SUMMARY");
      return;
    }
    if(atExcluded){
      movePhotosFunction("EXCLUDED", "SUMMARY");
    }*/
  }

  /**
   * Move to Stand-by container
   */
  void moveToStandBy(){
    print("MOVING TO STANDY");
    movePhotosFunction("SUMMARY", "STANDBY"); //TODO JUST TESTING
    cleanAll();
  }

  /**
   * Move to excluded container
   */
  void moveToExcluded(){
    movePhotosFunction("CHANGE", "EXCLUDED");
    cleanAll();
  }

  /**
   * move function front end
   */
  void movePhotosFunction(String origin, String destination){
    List<Thumbnail> thumbsToMove = new List<Thumbnail>();
    for(String photoToMove in this.selectedPhotos){
      thumbsToMove.add(returnThumbnail(origin, photoToMove));
    }
    print("Ja tenho os thumbs para mover. Tamanho: " + thumbsToMove.length.toString());
    moveFromTo(origin, destination, thumbsToMove);
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
      printContainersSize();
    }
    this.myDataBase.moveFromTo(from, to, thumbNames);
  }

  void printContainersSize(){
    print("§§§§§§§§§§§§§§§§§");
    print("Summary container: " + this.thumbnailsSummary.length.toString());
    print("Stand-by container: " + this.thumbnailsStandBy.length.toString());
    print("Excluded container: " + this.thumbnailsExcluded.length.toString());
    print("§§§§§§§§§§§§§§§§§");
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

  /**
   * Add to selected Photos List
   */
  void addToSelectedPhotos(String photoName){
    this.selectedPhotos.add(photoName);
  }

  /**
   * Remove from selected Photos List
   */
  void removeFromSelectedPhotos(String photoName){
    this.selectedPhotos.remove(photoName);
  }

  void cleanSelectedElements(){
    this.selectedElements.clear();
  }

  void addToSelectedElements(Element element){
    this.selectedElements.add(element);
  }

  void removeFromSelectedElements(Element element){
    this.selectedElements.remove(element);
  }

  List<Element> returnAllSelectedElements(){
    return this.selectedElements;
  }

  /**
   * Clean All
   */
  void cleanAll(){
    cleanSelectedElements();
    cleanSelection();
  }

  /**
   * Clean selected objects _ Used when the user cancel the selection operation
   */
  void cleanSelection(){
    for(Element element in this.selectedElements){
      element.attributes['selected'] = "false";
    }
    this.selectedElements.clear();
    this.selectedPhotos.clear();

    /*
    var imageDivElement = null;
    var index = 4;
    var selectedSize = this.selectedPhotos.length + 5;
    for(String photoName in this.selectedPhotos){
      print("Photo Selected Name: " + photoName);
      for(int i = index; i < selectedSize; i++){
        imageDivElement = $['justTest'].children[index];
        if(imageDivElement.getAttribute("id") == photoName){
          imageDivElement.children[0].setAttribute("selected", "false");
        }
      }
    }*/
  }

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
        print(nameOfPhoto + " is selected?" + isSelected);
      }
      else{
        target.attributes['selected'] = "true";
        addToSelectedPhotos(nameOfPhoto);
        addToSelectedElements(target);
        print(nameOfPhoto + " is selected?" + isSelected);
      }
    }
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

  void displayPhoto(){
    router.go("big-size-photo", {});
  }

}