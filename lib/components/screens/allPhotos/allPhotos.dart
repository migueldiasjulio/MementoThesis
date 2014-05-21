library allPhotos;

import 'dart:html';
import 'dart:core';
import 'package:polymer/polymer.dart';
import 'package:route_hierarchical/client.dart';
import '../../core/ScreenModule.dart' as screenhelper;
import '../../core/Thumbnail.dart';
import 'package:bootjack/bootjack.dart';
import 'dart:convert' show HtmlEscape;
import 'dart:async';

/**
 * TODO
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
 
  /**
   *     Photo database
   */
  final List<String> photoSources = toObservable([]);
  final List<Thumbnail> thumbnails = toObservable([]);
  
  /**
   * TODO
   */
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
  
  @override
  void enteredView() {
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
  
  /**
   * Input photos
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
    // _readForm.reset();
     _onFilesSelected(event.dataTransfer.files);
   }

   /**
    * TODO
    */
   void _onFileInputChange() {
     _onFilesSelected(_fileInput.files);
     //hiddeLoading();
   }
   
   /**
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
                               print("Thumbs size: " + this.thumbnails.length.toString());
                            });
                            reader.readAsDataUrl(file);
                   });
     
     completer.complete(workToDo);
     return completer.future;

   }
   
   void _onFilesSelected(List<File> files) {
     
     var photoFiles = files.where((file) => file.type.startsWith('image'));
     
     //photos.addAll(photoFiles);     
/*
     //RUN THIS
     Future future = getData(photoFiles);
     //THEN
     future  
       .then((workToDo) => closeAndUpdateNumber())  
       .catchError((e) => print(e));  */
     
     showLoading();
     
     photoFiles.forEach((file) {
                                 FileWriter writer;
                                 FileReader reader = new FileReader();
                                 reader.onLoad.listen((e) {
                                   //FILE SRC
                                   this.photoSources.add(reader.result);
                                   //FILE THUMBNAIL
                                    this.thumbnails.add(new Thumbnail(reader.result, title: sanitizer.convert(file.name)));
                                    print("Thumbs size: " + this.thumbnails.length.toString());
                                 });
                                 reader.readAsDataUrl(file);
                        });
     
     closeAndUpdateNumber();
   }
   
   void closeAndUpdateNumber(){
     hiddeLoading();
     String thumbSize = this.thumbnails.length.toString();
     numberOfPhotosDefined = thumbSize;
   }

   
   /**
    *
    */
   void show(){
     modal.show();
   }
   
   /**
    *
    */
   void showLoading(){
     loading.show();
   }
   
   /**
    *
    */
   void hiddeLoading(){
     loading.hide();
   }
   
   /**
    *
    */
   void incSummaryNumber(){
     int auxiliar = int.parse(numberOfPhotosDefined);
     if(auxiliar == thumbnails.length){
       this.numberOfPhotosDefined = auxiliar.toString();
     } else{
       auxiliar++;
       this.numberOfPhotosDefined = auxiliar.toString();
     }
   }
   
   /**
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
  
   /**
    * TODO
    */
   void runStartStuff(){}

   /**
    * Build Summary
    */
    void buildSummary(){
      
      //SHOW LOADING WINDOW
      
      //1 enviar dados para a db
      addPhotosToDataBase();
      //2 construir sumario
      this.myDataBase.workFirstXSummary(int.parse(this.numberOfPhotosDefined));
      //ir para o ecra
      goSummary();
      
      //HIDDE LOADING WINDOW
    }
    
    /**
     *
     */
    void addPhotosToDataBase(){
      myDataBase.addNewElementsToDataBase(photoSources, thumbnails);
    }

    /**
     *
     */
   void goSummary(){
     router.go("summary-done", {});
     modal.hide();
   }

   /**
    * TODO
    */
   void cleaner(){
     //thumbnails.clear();
   }

   
}///allPhotos