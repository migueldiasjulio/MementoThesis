library allPhotos;

import 'dart:html';
import 'dart:core';
import 'package:polymer/polymer.dart';
export "package:polymer/init.dart";
import 'package:route_hierarchical/client.dart';
import '../../core/screenModule.dart' as screenhelper;
import '../../core/photo/photo.dart';
import 'package:bootjack/bootjack.dart';
import 'dart:convert' show HtmlEscape;
import '../../core/database/dataBase.dart';
import '../../core/exif/exifExtractor.dart';
import '../../core/exif/exifManager.dart';
import 'dart:math';

/*
 * All Photos Screen class
 */
@CustomTag(AllPhotos.TAG)
class AllPhotos extends screenhelper.Screen {

  static const String TAG = "all-photos";
  String title = "All Photos",
   description = "Showing all photos";
  factory AllPhotos() => new Element.tag(TAG);
  final _exifExtractor = ExifExtractor.get(); //TODO tirar
  final _exifManager = ExifManager.get();

  Modal summaryCreation;
  Modal loading;
  Modal maximumPhotos;

  InputElement _fileInput;

  Element _dropZone;
  HtmlEscape sanitizer = new HtmlEscape();
  Element _addPhotos;
  @observable String numberOfPhotosDefined = "20";
  int numberOfPhotosLoaded = 0;
  Element startSummary;
  
  final List<Photo> photos = toObservable([]);

  AllPhotos.created() : super.created(){
    Modal.use();
    summaryCreation = Modal.wire($['summaryCreation']);
    loading = Modal.wire($['loading']);
    maximumPhotos = Modal.wire($['maximumPhotos']);

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
   }

   /*
    * On file Input
    */
   void _onFileInputChange() {
     _onFilesSelected(_fileInput.files);
   }
   
   /*
    *
    */
   void _onFilesSelected(List<File> files) {     
     var number = 0,
         photoFiles = files.where((file) => file.type.startsWith('image'));
     numberOfPhotosDefined = (photos.length + photoFiles.length).toString();
     numberOfPhotosLoaded = int.parse(numberOfPhotosDefined);
     var intNumber = photoFiles.length,
         dateInformation = 0.0,
         photoToAdd = null,
         photosBackUp = new List<Photo>();

    if(intNumber > 0){
      showLoading();
    }
    photoFiles.forEach((file) {
      var rng = new Random();
      FileReader reader = new FileReader();
      reader.onLoad.listen((e) {
        photoToAdd = new Photo(reader.result, file.name);
        //dateInformation = DB.extractExifInformation(photoToAdd);
        //print("Tem EXIF? " + _exifExtractor.imageHasData(photoToAdd.image).toString());
        dateInformation = rng.nextDouble();
        photoToAdd.setDataFromPhoto(dateInformation);
        photosBackUp.add(photoToAdd);
        number++;
        
        if(number == intNumber){
          photos.addAll(photosBackUp);
          DB.sortPhotos(photos);
          photosBackUp = new List<Photo>();
          this.hiddeLoading();
        }
      });
      reader.readAsDataUrl(file);
    });
   }
   
   /*
    * Show upload photos loading modal
    */
   void showSummaryBeenCreating(){
     summaryCreation.show();
   }
   
   /*
    *
    */
   void hiddeSummaryBeenCreating(){
     summaryCreation.hide();
   }

   /*
    *
    */
   void showLoading(){
     loading.show();
   }

   /*
    * 
    */
   void hiddeLoading(){
     loading.hide();
   }

   /*
    * Increment number of summary photos
    */
   void incSummaryNumber(){
     var auxiliar = int.parse(numberOfPhotosDefined);
     if(auxiliar == photos.length){
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
     var auxiliar = int.parse(numberOfPhotosDefined);
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
   void runStartStuff();

   /*
    * Build Summary
    */
    void buildSummary(){
      var result;
      var numberDefinedInt = int.parse(numberOfPhotosDefined);
      if(numberDefinedInt > numberOfPhotosLoaded){
        showMessageNumberOverflow();
      }else{
        result = DB.buildSummary(photos, numberDefinedInt);
      }
      if(result){
        goSummary();
      }
    }
    
    void summaryWithMaxNumber(){
      var result = DB.buildSummary(photos, numberOfPhotosLoaded);
      if(result){
        hideMessageNumberOverflow();
        goSummary();
      }
    }
    
    /*
     * 
     */
    void showMessageNumberOverflow(){
      maximumPhotos.show();
    }
    
    /*
     * 
     */
    void hideMessageNumberOverflow(){
      maximumPhotos.hide();
    }

   /*
    *
    */
   void goSummary(){
     router.go("summary-done", {});
     
   }
   
   /*
    * Open file uploader
    */
   void openFileUploader(){
     _fileInput.click();
   }

}