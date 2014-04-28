library dragAndDrop;

import 'dart:async';
import 'dart:html';
import 'package:polymer/polymer.dart';
import 'resources/screenModule.dart' as memento;
import 'dart:convert' show HtmlEscape;
import 'core/dataBase.dart';

/// A [Thumbnail] model
class Thumbnail {
  String src, title;
  int width, height;

  Thumbnail(this.src, {this.title, this.width: 140, this.height: 140});
}
/**
 * TODO
 */
@CustomTag(DragAndDrop.TAG)
class DragAndDrop extends memento.Screen {
  /**
   * TODO
   */
   FormElement _readForm;
   InputElement _fileInput;
   Element _dropZone;
   OutputElement _output;
   HtmlEscape sanitizer = new HtmlEscape();
   String myPhotosPath;
   String myThumbnailsPath;   

   /**
    * TODO
    */
   static const String TAG = "drag-and-drop";
  
  //Map<String, screen> get screens => screens;
  
  //Map<String, screen> modulesApp = mementoApp.modules;
  
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
  }

  /**
   * TODO
   */
   DragAndDrop.created() : super.created() {
    _readForm = $['read'];
    _fileInput = $['files'];
    _dropZone = $['drop-zone'];
    
    _fileInput.onChange.listen((e) => _onFileInputChange());
    _dropZone.onDragOver.listen(_onDragOver);
    _dropZone.onDragEnter.listen((e) => _dropZone.classes.add('hover'));
    _dropZone.onDragLeave.listen((e) => _dropZone.classes.remove('hover'));
    _dropZone.onDrop.listen(_onDrop);
  }
  
  void sendInformation(){
    
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
    super.enteredView();
  }
  
  /**
   * TODO
   */
  @override
   void setupRoutes(Route route) {
    String nome = "all-photos";
    route.addRoute(
        name: 'home',
        path: '',
        enter: home);
    /*
    route.addRoute(
        name: nome,
         path: '/$nome',
         mount: new allPhotos().mount(nome, router),
         enter: (e) {
           new allPhotos();});
           */
   }
 
  /**
   * TODO
   */
  home(_) {}

  /**
   * TODO
   */
  select(event, detail, target) {
    // <type>-<id>
    var id = target.dataset["id"].split("-");
    router.go("$path.view", {"type": id[0], "id": id[1]});
  }
  
  /**
   * TODO
   */
  goAllPhotos(){
    this.addPhotosToDataBase();
    router.go('all-photos', {});
  }
  
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
   
   void addPhotosToDataBase(){
     myDataBase.addNewElementsToDataBase(photos, thumbnails);
   }

   /**
    * TODO
    */
   void _onFilesSelected(List<File> files) {
     print("${photos.length} original photos");
     print("${thumbnails.length} thumbnail photos");

     var photoFiles = files.where((file) => file.type.startsWith('image'));

     // Add original files
     photos.addAll(photoFiles);

     // read and display its thumbnail.
     photoFiles.forEach((file) {
       var reader = new FileReader();
       reader.onLoad.listen((e) {
          thumbnails.add(new Thumbnail(reader.result, title: sanitizer.convert(file.name)));
       });
       reader.readAsDataUrl(file);
     });
   } 
 }