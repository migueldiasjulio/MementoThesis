library allPhotos;

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:route_hierarchical/client.dart';
import 'resources/ScreenModule.dart' as screenhelper;
import 'core/DataBase.dart';
import 'core/Thumbnail.dart';

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

  /**
   * TODO
   */
  AllPhotos.created() : super.created(){
    _thumbnailsToShow = new List<String>();
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
  
  ///
  ///

  
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
  
  void goToAddPhotos(){
    router.go("drag-and-drop", {});
  }
  
  void doSummary(){
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