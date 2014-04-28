library dragAndDrop;

import 'dart:html' show Element;
import 'package:polymer/polymer.dart';
import 'resources/screenModule.dart';
import 'dart:convert' show HtmlEscape;
import 'core/dataBase.dart';

/*
Map<String, screen> screens = {
  "all-photos": new dragAndDrop()
};*/

/**
 * TODO
 */
@CustomTag(DragAndDrop.TAG)
class DragAndDrop extends Screen {
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
  List<File> photoLoaded = new List<File>(); 
  List<ImageElement> photoLoadedThumbnail = new List<ImageElement>();
  
  /**
   * TODO
   */
  void cleanPhotoLoaded(){
    photoLoaded = new List<File>();
    photoLoadedThumbnail = new List<ImageElement>();
  }
  
  /**
   * TODO
   */
  void addPhotosToList(List<File> files){
    photoLoaded.addAll(files);
  }
  
  /**
   * TODO
   */
  void addThumbnailsToList(List<ImageElement> files){
    photoLoadedThumbnail.addAll(files);
  }
  

  /**
   * TODO
   */
  void cleaner(){
    //clean string
    cleanOutputList();
  }
  
  /**
   * TODO
   */
  void cleanOutputList(){
    _output.nodes.clear();
    cleanPhotoLoaded();   
  }
  
  /**
   * TODO
   */
  void cleanAuxLists(){
    this.photoLoaded = new List<File>();
    this.photoLoadedThumbnail = new List<ImageElement>();
  }

  /**
   * TODO
   */
   DragAndDrop.created() : super.created() {
    _output = $["list"];
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
     event.stopPropagation();
     event.preventDefault();
     event.dataTransfer.dropEffect = 'copy';
   }

   /**
    * TODO
    */
   void _onDrop(MouseEvent event) {
     event.stopPropagation();
     event.preventDefault();
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
     this.myDataBase.addNewElementsToDataBase(this.photoLoaded, this.photoLoadedThumbnail);
   }

   /**
    * TODO
    */
   void _onFilesSelected(List<File> files) {
     print("Original photos list size: " + this.photoLoaded.length.toString());
     print("Thumbnail photos list size: " + this.photoLoadedThumbnail.length.toString());
     //original files added
     this.addPhotosToList(files);
     
     List<ImageElement> thumb = new List<ImageElement>();
     
     var list = new Element.tag('ul');
     for (var file in files) {
       var item = new Element.tag('li');
       var thumbnail = new ImageElement();

       // If the file is an image, read and display its thumbnail.
       if (file.type.startsWith('image')) {
         var thumbHolder = new Element.tag('span');
         var reader = new FileReader();
         reader.onLoad.listen((e) {
           
           thumbnail.src = reader.result;
           thumbnail.width = 140;
           thumbnail.width = 140;
           thumbnail.classes.add('thumb');
           
           thumbnail.title = sanitizer.convert(file.name);
           thumbHolder.nodes.add(thumbnail);       
         });
         reader.readAsDataUrl(file);
         item.nodes.add(thumbHolder);
       }

       /**
        * For all file types, display some properties.
        */
       var properties = new Element.tag('span');
       properties.innerHtml = (new StringBuffer('<strong>')
           ..write(sanitizer.convert(file.name))
       ).toString();
       item.nodes.add(properties);
       list.nodes.add(item);
       //adding
       thumb.add(thumbnail);
     }
     this.addThumbnailsToList(thumb);
     print("Original photos list size: " + this.photoLoaded.length.toString());
     print("Thumbnail photos list size: " + this.photoLoadedThumbnail.length.toString());
     
     _output.nodes.add(list);
   } 
 }