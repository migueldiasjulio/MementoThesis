library dragAndDrop;

import 'package:polymer/polymer.dart';
import 'resources/screenModule.dart';
import 'dart:convert' show HtmlEscape;
import 'dart:html';

/*
Map<String, screen> MODULES = {
  "all-photos": new dragAndDrop()
};*/

/**
 * TODO
 */
@CustomTag(TAG)
class dragAndDrop extends screen {
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
  
  //Map<String, screen> get modules => MODULES;
  
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
  factory dragAndDrop() => new Element.tag(TAG);
  
  /**
   *     Photo database
   */
  List<File> photoLoaded = new List<File>();
  
  /**
   * TODO
   */
  void cleanPhotoLoaded(){
    photoLoaded = new List<File>();
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
  void cleaner(){
    //clean string
    cleanOutputList();
  }
  
  /**
   * TODO
   */
  void cleanOutputList(){
    _output.nodes.clear();
  }

  /**
   * TODO
   */
  dragAndDrop.created() : super.created() { 
    _output = shadowRoot.querySelector("#list"); 
    _readForm = shadowRoot.querySelector('#read');
    _fileInput = shadowRoot.querySelector('#files');  
    _dropZone = shadowRoot.querySelector('#drop-zone');
  }
  
  /**
   * TODO
   */
  void runStartStuff(){
    _fileInput.onChange.listen((e) => _onFileInputChange());
    _dropZone.onDragOver.listen(_onDragOver);
    _dropZone.onDragEnter.listen((e) => _dropZone.classes.add('hover'));
    _dropZone.onDragLeave.listen((e) => _dropZone.classes.remove('hover'));
    _dropZone.onDrop.listen(_onDrop);  
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
    print(_fileInput.toString());
     _onFilesSelected(_fileInput.files);
   }

   /**
    * TODO
    */
   void _onFilesSelected(List<File> files) {
     this.addPhotosToList(files);
     //_output.nodes.clear();
     var list = new Element.tag('ul');
     for (var file in files) {
       var item = new Element.tag('li');

       // If the file is an image, read and display its thumbnail.
       if (file.type.startsWith('image')) {
         var thumbHolder = new Element.tag('span');
         var reader = new FileReader();
         reader.onLoad.listen((e) {
           var thumbnail = new ImageElement(src: reader.result);
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
           ..write('</strong> (')
           ..write(file.type != null ? sanitizer.convert(file.type) : 'n/a')
           ..write(') ')
           ..write(file.size)
           ..write(' bytes')
           // TODO(jason9t): Re-enable this when issue 5070 is resolved.
           // http://code.google.com/p/dart/issues/detail?id=5070
           // ..add(', last modified: ')
           // ..add(file.lastModifiedDate != null ?
           //       file.lastModifiedDate.toLocal().toString() :
           //       'n/a')
       ).toString();
       item.nodes.add(properties);
       list.nodes.add(item);
     }
     _output.nodes.add(list);
   } 
 }