library allPhotos;

import 'dart:html';
import 'dart:core';
import 'dart:async';
import 'package:polymer/polymer.dart';
export "package:polymer/init.dart";
import 'package:route_hierarchical/client.dart';
import '../../core/screenModule.dart' as screenhelper;
import '../../core/Thumbnail.dart';
import 'package:bootjack/bootjack.dart';
import 'dart:convert' show HtmlEscape;

/*
 * All Photos Screen class
 */
@CustomTag(AllPhotos.TAG)
class AllPhotos extends screenhelper.Screen {

  final String _fixedNumberOfPhotos = "20";
  static const String TAG = "all-photos";
  String title = "All Photos",
   description = "Showing all photos";
  factory AllPhotos() => new Element.tag(TAG);

  Modal modal;
  Modal loading;

  InputElement _fileInput;
  
  FileReader _reader;

  Element _dropZone;
  HtmlEscape sanitizer = new HtmlEscape();
  Element _addPhotos;
  @observable String numberOfPhotosDefined = "20";
  Element startSummary;

  /*
   *     Photo database
   */
  final List<String> photoSources = toObservable([]);
  final List<Thumbnail> thumbnails = toObservable([]);

  AllPhotos.created() : super.created(){
    Modal.use();
    Transition.use();
    modal = Modal.wire($['modal']);
    loading = Modal.wire($['loading']);

    _fileInput = $['files'];
    _dropZone = $['drop-zone'];
    _addPhotos= $['addPhotos'];
    startSummary = $['startSummary'];

    _fileInput.onChange.listen((e) => _onFileInputChange());
    _dropZone.onDragOver.listen(_onDragOver);
    _dropZone.onDragEnter.listen((e) => _dropZone.classes.add('hover'));
    _dropZone.onDragLeave.listen((e) => _dropZone.classes.remove('hover'));
    _dropZone.onDrop.listen(_onDrop);
  }

  /*
   * Entering View
   */ 
  @override
  void enteredView() {
    super.enteredView();
  }

  /*
   * Setup Routes
   * @param route - Route
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
   * On drag over
   * @param event - MouseEvent
   */
   void _onDragOver(MouseEvent event) {
     event
     ..stopPropagation()
     ..preventDefault()
     ..dataTransfer.dropEffect = 'copy';
   }

   /*
    * On Drop (drop zone)
    * @param event - MouseEvent 
    */
   void _onDrop(MouseEvent event) {
     event..stopPropagation()..preventDefault();
     _dropZone.classes.remove('hover');
     _onFilesSelected(event.dataTransfer.files);
     closeAndUpdateNumber();
   }

   /*
    * On file Input
    */
   void _onFileInputChange() {
     _onFilesSelected(_fileInput.files);
     closeAndUpdateNumber();
   }

   /*
    * Future so import and modal can run at the same time
    */
   Future getData(var photoFiles){
     var completer = new Completer();
     var workToDo = photoFiles.forEach((file) {
                            FileWriter writer;
                            FileReader reader = new FileReader();
                            reader.onLoad.listen((e) {
                              //FILE SRC
                              this.photoSources.add(reader.result);
                              //FILE THUMBNAIL
                               this.thumbnails.add(new Thumbnail(reader.result, title: sanitizer.convert(file.name)));
                            });
                            reader.readAsDataUrl(file);
                   });
     completer.complete(workToDo);
     return completer.future;
   }

   void _onFilesSelected(List<File> files) {
     
     var photoFiles = files.where((file) => file.type.startsWith('image'));
     this.numberOfPhotosDefined = (this.thumbnails.length + photoFiles.length).toString();

     //photos.addAll(photoFiles);
      /*
     //RUN THIS
     Future future = getData(photoFiles);
     //THEN
     future
       .then((workToDo) => closeAndUpdateNumber())
       .catchError((e) => print(e));  */

     //TODO Modal loading
     //showLoading();
     ImageElement image;

     photoFiles.forEach((file) {
                                 FileWriter writer;
                                 FileReader reader = new FileReader();
                                 reader.onLoad.listen((e) {
                                   //FILE SRC
                                   this.photoSources.add(reader.result);
                                   //FILE THUMBNAIL
                                    this.thumbnails.add(new Thumbnail(reader.result, title: sanitizer.convert(file.name)));
                                 });
                                 reader.readAsDataUrl(file);
                        } );
   }

   /*
    * When all files were uploaded update the number
    * of thumbnails.size so the user can create a 
    * new summary
    */ 
   void closeAndUpdateNumber(){
     //hiddeLoading();
   }

   /*
    * Show upload photos loading modal
    */
   void show(){
     modal.show();
   }

   /*
    *Show loading modal creating a summary
    */
   void showLoading(){
     loading.show();
   }

   /*
    * Hide loading modal creating a summary
    */
   void hiddeLoading(){
     loading.hide();
   }

   /*
    * Increment number of summary photos 
    */
   void incSummaryNumber(){
     int auxiliar = int.parse(numberOfPhotosDefined);
     if(auxiliar == this.thumbnails.length){
       this.numberOfPhotosDefined = auxiliar.toString();
     } else{
       auxiliar++;
       this.numberOfPhotosDefined = auxiliar.toString();
     }
   }

   /*
    *
    */
   void subSummaryNumber(){
     int auxiliar = int.parse(numberOfPhotosDefined);
     if(auxiliar == 1){
       this.numberOfPhotosDefined = auxiliar.toString();
     } else{
       auxiliar--;
       this.numberOfPhotosDefined = auxiliar.toString();
     }
   }

   /*
    * 
    */
   void runStartStuff(){}

   /**
    * Build Summary
    */
    void buildSummary(){

      //SHOW LOADING WINDOW
      addPhotosToDataBase();
      this.myDataBase.decideAlgorithm(int.parse(this.numberOfPhotosDefined));
      goSummary();
      //HIDDE LOADING WINDOW
    }

    /*
     *
     */
    void addPhotosToDataBase(){
      myDataBase.addNewElementsToDataBase(photoSources, thumbnails);
    }

    /*
     *
     */
   void goSummary(){
     router.go("summary-done", {});
     modal.hide();
   }
   
   /*
    * Open file uploader
    */
   void openFileUploader(){
     _fileInput.click();
   }
   
   void openFileUploader2(){
     _fileInput.click();
   }

}///allPhotos