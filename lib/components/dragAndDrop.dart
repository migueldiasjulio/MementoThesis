library dragAndDrop;

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:route_hierarchical/client.dart';
import 'resources/ScreenModule.dart' as screenmodule;
import 'dart:convert' show HtmlEscape;
import 'core/DataBase.dart';
import 'core/Thumbnail.dart';

/**
 * TODO
 */
@CustomTag(DragAndDrop.TAG)
class DragAndDrop extends screenmodule.Screen {
  /**
   * TODO
   */
   FormElement _readForm;
   InputElement _fileInput;
   Element _dropZone;
   HtmlEscape sanitizer = new HtmlEscape(); 
   var _numberOfPhotosToAdd = 0;
   Element _loadingBarPhotosDiv;
   var _numberOfPhotosToAddElement;
   Element _modalPopUp;
   @observable bool visible = true;
   int dataBaseVersion;  

   /**
    * TODO
    */
   static const String TAG = "drag-and-drop";
  
   /**
    * TODO
    */
  static bool already = false;

  /**
   * TODO
   */
  String title = "Drag and Drop Screen",
         description = "Drag and Drop photos here";

  /**
   * TODO
   */
  @observable Selection selection = null;

  /**
   * TODO
   */
  factory DragAndDrop() => new Element.tag(TAG);
  
  /**
   *     Photo database
   */
  final List<File> photos = toObservable([]);
  final List<Thumbnail> thumbnails = toObservable([]);

  /**
   * TODO
   */
  void cleaner(){
    photos.clear();
    thumbnails.clear();
    resetNumberOfPhotos();
  }
  
  void runAgain(){
    _readForm.reset();
  }
  
  void resetNumberOfPhotos(){
    $['numberOfPhotos'].text = '0 photos selected.'; 
  }
  
  void setNewNumberOfPhotos(int newNumber){
    $['numberOfPhotos'].text = newNumber.toString() + " photos selected.";
  }

  /**
   * TODO
   */
   DragAndDrop.created() : super.created() {
    _readForm = $['read'];
    _fileInput = $['files'];
    _dropZone = $['drop-zone'];
    _loadingBarPhotosDiv = $['loadBarAndText'];
    
    _fileInput.onChange.listen((e) => _onFileInputChange());
    _dropZone.onDragOver.listen(_onDragOver);
    _dropZone.onDragEnter.listen((e) => _dropZone.classes.add('hover'));
    _dropZone.onDragLeave.listen((e) => _dropZone.classes.remove('hover'));
    _dropZone.onDrop.listen(_onDrop);
    
  }
  
  /**
   * TODO
   */
  void runStartStuff(dataBase _myDataBase){
    this.myDataBase = _myDataBase;
    cleaner();   
  }

  /**
   * TODO
   */
  @override
  void enteredView() {
    runAgain(); ///reseting form
    dataBaseVersion = this.myDataBase.returnVersion();
    super.enteredView();
  }
  
  /**
   * TODO
   */
  @override
   void setupRoutes(Route route){
    route.
    addRoute(
        name: 'home',
        path: '',
        enter: home);
   }
 
  /**
   * TODO
   */
  home(_) {}
  
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
   
   void goToAllPhotos(){
    visible = true;
    /// activateProgressBar();
     addPhotosToDataBase();
     cleaner();
    /// inactiveProgressBar();
     router.go("all-photos", {});
   }
   
   void activateProgressBar(){
     _loadingBarPhotosDiv.hidden = false;
   }
   
   void inactiveProgressBar(){
     _loadingBarPhotosDiv.hidden = true;
   }
   
   void setInitialProgressBarValues(String finalValue){
     $['numberOfPhotos'].setAttribute("aria-valuemax", finalValue);  
   }
   
   void updateLiveValueOfProgressBar(String valueNow){
     $['numberOfPhotos'].setAttribute("aria-valuenow", valueNow);
     var numberX = int.parse(valueNow)/(int.parse($['numberOfPhotos'].getAttribute("aria-valuemax")));
     $['numberOfPhotos'].setAttribute("style", "width: " + numberX.toString() + "%");
     
   }

   /**
    * TODO
    */
   void _onFilesSelected(List<File> files) {

     var photoFiles = files.where((file) => file.type.startsWith('image'));
       
     // Add original files
     photos.addAll(photoFiles);
     setNewNumberOfPhotos(photos.length);
     setInitialProgressBarValues(photos.length.toString());

     var aux = 0;  
     // read and display its thumbnail.
     photoFiles.forEach((file) {
       updateLiveValueOfProgressBar(aux.toString());
       var reader = new FileReader();
       reader.onLoad.listen((e) {
          thumbnails.add(new Thumbnail(reader.result, title: sanitizer.convert(file.name), 
              dataBaseVersion: dataBaseVersion));
       });
       reader.readAsDataUrl(file);
     });
     
     //inactiveProgressBar();
   } 
 }