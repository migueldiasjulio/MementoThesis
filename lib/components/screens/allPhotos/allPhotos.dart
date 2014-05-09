library allPhotos;

import 'dart:html';
import 'dart:core';
import 'package:polymer/polymer.dart';
import 'package:route_hierarchical/client.dart';
import '../../core/screenModule.dart' as screenhelper;
import '../../core/Thumbnail.dart';
import 'package:bootjack/bootjack.dart';
import 'dart:convert' show HtmlEscape;
import 'dart:async';

/**
 * TODO
 */
@CustomTag(AllPhotos.TAG)
class AllPhotos extends screenhelper.Screen {

  List<String> _thumbnailsToShow;
  static const String TAG = "all-photos";
  String title = "All Photos",
         description = "Showing all photos";
  factory AllPhotos() => new Element.tag(TAG);
  Modal modal;
  @published String numberOfPhotosDefined = "20";

  FormElement _readForm;
  InputElement _fileInput;
  Element _dropZone;
  HtmlEscape sanitizer = new HtmlEscape();
  var _numberOfPhotosToAdd = 0;
  Element _addPhotos;
  
  /**
   *     Photo database
   */
  final List<File> photos = toObservable([]);
  final List<Thumbnail> thumbnails = toObservable([]);

  int convertToInt(String number){
    return int.parse(number);
  }
  
  /**
   * TODO
   */
  AllPhotos.created() : super.created(){
    _thumbnailsToShow = new List<String>();
    Modal.use();
    Transition.use();
    modal = Modal.wire($['modal']);

    _readForm = $['read'];
    _fileInput = $['files'];
    _dropZone = $['drop-zone'];
    _addPhotos= $['addPhotos'];
    
    _fileInput.onChange.listen((e) => _onFileInputChange());
    _dropZone.onDragOver.listen(_onDragOver);
    _dropZone.onDragEnter.listen((e) => _dropZone.classes.add('hover'));
    _dropZone.onDragLeave.listen((e) => _dropZone.classes.remove('hover'));
    _dropZone.onDrop.listen(_onDrop);
    //_addPhotos.onClick.listen((e) => _fileInput.);
  }

  @override
  void enteredView() {
    //this.importThumbnailPhotos();
    super.enteredView();
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

  void show(){
    modal.show();
  }

  
  /**
   * TODO
   */
  void runStartStuff(){}
  /**
   * Messages to be displayed
   */
  void noPhotosMessage(){
    $['message'].text = "You need to import at least 1 photo to proceed.";
  }

  void littleNumberMessage(){
    $['message'].text = numberOfPhotosDefined + " photos defined  as the summary size but only "
        + this.thumbnails.length.toString() + " photos were imported. Continue?";
  }

  void informativeSummaryMessage(){
    $['message'].text = "A summary with " + numberOfPhotosDefined + " will be created. Continue?";
  }

  void setNumberOfPhotosToSummary(int number){
    numberOfPhotosDefined = number.toString();
  }

  /**
   * Do Summary
   */
  void doSummary(){
    print(numberOfPhotosDefined);
    int thumbSize = this.thumbnails.length;
    show();
    if(thumbSize == 0){
      noPhotosMessage();
    } else if(thumbSize < int.parse(numberOfPhotosDefined)){
      littleNumberMessage();
    } else {
      informativeSummaryMessage();
    }
  }

  /**
   * Build Summary
   */
   void buildSummary(){
     //TODO progressbar
     goSummary();
     modal.hide();
   }

  void goSummary(){
    router.go("summary-done", {});
  }

  /**
   * TODO
   */
  void cleaner(){
    thumbnails.clear();
  }

  /**
   * Input photos
   */
  /**
   * TODO
   */
   void _onDragOver(MouseEvent event) {
     event
     ..stopPropagation()
     ..preventDefault()
     ..dataTransfer.dropEffect = 'copy';
   }

   /**
    * TODO
    */
   void _onDrop(MouseEvent event) {
     event..stopPropagation()..preventDefault();
     _dropZone.classes.remove('hover');
     _readForm.reset();
     _onFilesSelected(event.dataTransfer.files);
   }

   /**
    * TODO
    */
   void _onFileInputChange() {
     _onFilesSelected(_fileInput.files);
   }

   /**
    *
    */
   void addPhotosToDataBase(){
     myDataBase.addNewElementsToDataBase(photos, thumbnails);
   }

   /**
    * Future so import and modal can run at the same time
    */
   Future<bool> readData(var photoFiles){
     var completer = new Completer();
     completer.complete(
       photoFiles.forEach((file) {
                            var reader = new FileReader();
                            reader.onLoad.listen((e) {
                               this.thumbnails.add(new Thumbnail
                                   (reader.result, title: sanitizer.convert(file.name)));
                            });
                            reader.readAsDataUrl(file);
                            })
     );

     return completer.future;
   }

   void importingTitle(){
     //$['modalTilte'].text = "Importing photos";  
   }

   void importingContent(){
     //$['message'].text = "Loading...";
   }

   void importingPhotosModal(){
     show();
     importingTitle();
     importingContent();
   }
   
   void closeAndUpdateNumber(){
     this.modal.hide();
     print("entrei");
     if(this.thumbnails.length < int.parse(this.numberOfPhotosDefined)){
       setNumberOfPhotosToSummary(this.thumbnails.length);
     }else {
       setNumberOfPhotosToSummary(int.parse(this.numberOfPhotosDefined));
     }
   }

   void _onFilesSelected(List<File> files) {

     var photoFiles = files.where((file) => file.type.startsWith('image'));
     photos.addAll(photoFiles);
     var aux = 0;
     
     Future<bool> futureResults = readData(photoFiles);
     futureResults.then((results) => closeAndUpdateNumber())
           .catchError((e) => print("UPS!"));
     importingPhotosModal();
  
   } 
}///allPhotos