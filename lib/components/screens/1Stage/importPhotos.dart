library importPhotos;

import 'dart:html';
import 'dart:core';
import 'package:polymer/polymer.dart';
export "package:polymer/init.dart";
import 'package:route_hierarchical/client.dart';
import '../defaultScreen/screenModule.dart' as screenhelper;
import '../../core/photo/photo.dart';
import 'package:bootjack/bootjack.dart';
import 'dart:convert' show HtmlEscape;
import '../../core/database/dataBase.dart';
import '../../core/exif/exifManager.dart';
import 'dart:async';
import '../screenAdvisor.dart';
import 'auxiliarFunctions/firstAuxFunctions.dart';
import '../workers/starter.dart';
import '../workers/summaryCreation.dart';
import 'dart:isolate';
import 'dart:js' as js show JsObject, context;

/*
 * Import Photos Screen class
 */
@CustomTag(ImportPhotos.TAG)
class ImportPhotos extends screenhelper.Screen {

  final _Starter = Starter.get();
  final _SummaryBuilder = SummaryCreation.get();
  final _firstAuxFunctions = FirstAuxFunctions.get();
  final _ScreenAdvisor = ScreenAdvisor.get();
  static const String TAG = "import-photos";
  String title = "Import Photos",
         description = "Showing all photos";
  factory ImportPhotos() => new Element.tag(TAG);
  final _exifManager = ExifManager.get();
  final ObservableList<Photo> photos = toObservable([]);
  Modal summaryCreation,
        loading,
        maximumPhotos;
  InputElement _fileInput;
  Element _dropZone,
          _addPhotos,
          startSummary,
          _sucessWithImport;
  HtmlEscape sanitizer = new HtmlEscape();
  @observable String numberOfPhotosDefined = "20";
  @observable String numberOfPhotosImported = "1";
  int numberOfPhotosLoaded = 0;
  @observable bool modified = false;
  @observable bool workIsComplete = false;
  ReceivePort receivePort = new ReceivePort();

  /*
   *
   */
  ImportPhotos.created() : super.created(){
    Modal.use();
    summaryCreation = Modal.wire($['summaryCreation']);
    loading = Modal.wire($['loading']);
    maximumPhotos = Modal.wire($['maximumPhotos']);

    _fileInput = $['files'];
    _dropZone = $['drop-zone'];
    _addPhotos= $['addPhotos'];
    startSummary = $['startSummary'];
    _sucessWithImport = $['sucessWithImport'];
    _sucessWithImport.hidden = true;

    _fileInput.onChange.listen((e) => _onFileInputChange());
    _dropZone.onDragOver.listen(_onDragOver);
    _dropZone.onDragEnter.listen((e) => _dropZone.classes.add('hover'));
    _dropZone.onDragLeave.listen((e) => _dropZone.classes.remove('hover'));
    _dropZone.onDrop.listen(_onDrop);

    //photos.changes.listen((records) => changeToModified());
  }

  /*
   *
   */
  void workIsCompleteModified(){
    print("THATS OK!");
  }

  /*
   *
   */
  void changeToModified(){
    modified = !modified;
  }

  /*
   * Entering View
   */
  @override
  void enteredView() => super.enteredView();

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
   void _onFileInputChange() => _onFilesSelected(_fileInput.files);

   /*
    *
    */
   void cancelImport(){
     _Starter.killFileReaders();
     hiddeLoading();
   }

   /*
    *
    */
   void _onFilesSelected(List<File> files) {
    //var faceDetector = new js.JsObject(js.context['FaceDetector'], []);
    DB.addFilesToList(files);

    var photoFiles = files.where((file) => file.type.startsWith('image')),
        intNumber = photoFiles.length;

    if(intNumber > 0){
      organizeAndDisplayData(showingData);
      var dateInformation = 0.0,
          fileReaders = new List<FileReader>(),
          files = photoFiles.toList();

      numberOfPhotosDefined = (photos.length + photoFiles.length).toString();
      numberOfPhotosImported = (photos.length + photoFiles.length).toString();
      numberOfPhotosLoaded = int.parse(numberOfPhotosDefined);
      showLoading();
      startWorking(files);
    }
   }

   /*
    *
    */
   void startWorking(List<File> filesToProcess) {
     receivePort = new ReceivePort();

     receivePort.listen((msg){
       if (msg is SendPort){
         msg.send("Alright");
       }else{
         photos.addAll(_Starter.damnPhotos);
         DB.sortPhotos(photos);
         _Starter.cleanProcessedPhotos();
         _Starter.cleanFileReaders();
         hiddeLoading();
       }
     });

     //!HACK
     Isolate.spawnUri(
             _Starter.runInIsolate(receivePort.sendPort, filesToProcess),
             [],
             receivePort.sendPort);
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
   void runStartStuff(){
     _ScreenAdvisor.setScreenType(title);
   }

   /*
    *
    */
   void startWorkingOnSummary(List<Photo> photos, int numberDefinedInt) {
     receivePort = new ReceivePort();

     receivePort.listen((msg){
       if (msg is SendPort){
         msg.send("Alright");
       }else{
         hiddeSummaryBeenCreating();
         goSummary();
       }
     });

     //!HACK
     Isolate.spawnUri(
             _SummaryBuilder.runInIsolate(receivePort.sendPort, photos, numberDefinedInt),
             [],
             receivePort.sendPort);
   }

   /*
    * Build Summary
    */
    void buildSummary(){
      var numberDefinedInt = int.parse(numberOfPhotosDefined);
      if((numberDefinedInt > numberOfPhotosLoaded) || (numberDefinedInt <= 0)){
        showMessageNumberOverflow();
      }else{
        showSummaryBeenCreating();
        startWorkingOnSummary(photos, numberDefinedInt);
      }
    }

    /*
     *
     */
    Future goSummary() => router.go("summary-manipulation", {});

    /*
     *  Cancel the Summary Creation
     */
    bool cancelSummaryCreation() => DB.cleanAllData();

    /*
     *
     */
    void showDataInformation(){
      toogleShowingData();
      changeToModified();
    }

    /*
     *
     */
    void organizeAndDisplayData(showingData) => _firstAuxFunctions.organizeAndDisplayData(showingData);

    /*
     * Modal function
     */
    void showSummaryBeenCreating() => summaryCreation.show();
    void hiddeSummaryBeenCreating() => summaryCreation.hide();
    void showLoading() => loading.show();
    void hiddeLoading() => loading.hide();
    void showMessageNumberOverflow() => maximumPhotos.show();
    void hideMessageNumberOverflow() => maximumPhotos.hide();

   /*
    * Open file uploader
    */
   void openFileUploader() => _fileInput.click();

}