library allPhotos;

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:route_hierarchical/client.dart';
import 'resources/ScreenModule.dart' as screenhelper;
import 'core/DataBase.dart';
import 'core/Thumbnail.dart';
import 'package:bootjack/bootjack.dart';

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
  final List<Thumbnail> thumbnails = toObservable([]);
  int dataBaseVersion = 0;
  Modal modal;
  @published String numberOfPhotosDefined = "20";

  /**
   * TODO
   */
  AllPhotos.created() : super.created(){
    _thumbnailsToShow = new List<String>();
    
    Modal.use();
    Transition.use();
    modal = Modal.wire($['modal']);
  }
  
  @override
  void enteredView() {
    //dataBaseVersion = this.myDataBase.returnVersion();
    this.importThumbnailPhotos();
    super.enteredView();
  }
  
  /**
   * TODO
   */
  void runStartStuff(dataBase _dataBase){
    if(myDataBase == null){
      this.myDataBase = _dataBase;
    }
  }
  
  /**
   * Messages to be displayed
   */
  void noPhotosMessage(){
    $['messageBeforeSummary'].text = "You need to import at least 1 photo to proceed.";  
  }
  
  void littleNumberMessage(){
    $['messageBeforeSummary'].text = numberOfPhotosDefined + " photos defined  as the summary size but only "
        + this.thumbnails.length.toString() + " photos were imported. Continue?";
  }
  
  void informativeSummaryMessage(){
    $['messageBeforeSummary'].text = "A summary with " + numberOfPhotosDefined + " will be created. Continue?";
  }

  void showImage(Event e){
    print(e.target.toString()); //TODO
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
  
  void doSummary(){
    print(numberOfPhotosDefined);
    int thumbSize = this.thumbnails.length;
    show();
    if(thumbSize == 0){
      noPhotosMessage(); //Se não houverem fotos display msg
    } else if(thumbSize < int.parse(numberOfPhotosDefined)){  //(numero de fotos definidas) Se houver fotos mas não tantas como pedido no sumário, avisar
      littleNumberMessage();
    } else { //(numero de fotos definidas) criar sumario com este numero de fotos
      informativeSummaryMessage();
    }
  }
    
   void buildSummary(){ 
     //TODO progressbar
     goSummary();
     modal.hide();
   }

  
  void goToAddPhotos(){
    router.go("drag-and-drop", {});
  }
  
  void goSummary(){
    router.go("summary-done", {});
  }
  
  ///
  void importThumbnailPhotos(){
    List<Thumbnail> auxiliar; ///
    int dbVersion = myDataBase.returnVersion();
    if(dbVersion != dataBaseVersion){
      auxiliar = myDataBase.getAllThumbnails(this.dataBaseVersion);   
      for(Thumbnail thumb in auxiliar){
        if(!(thumbnails.contains(thumb))){
        thumbnails.add(thumb);
        }
      }
      dataBaseVersion = auxiliar.first.dataBaseVersion;
    }
  }
  /**
   * TODO
   */
  void cleaner(){
    thumbnails.clear();
  }

}///allPhotos