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

  List<Thumbnail> _thumbnailsToShow; 
  static const String TAG = "all-photos";
  String title = "All Photos",
         description = "Showing all photos";
  factory AllPhotos() => new Element.tag(TAG);
  final List<Thumbnail> thumbnails = toObservable([]);

  /**
   * TODO
   */
  AllPhotos.created() : super.created(){
    _thumbnailsToShow = new List<Thumbnail>();
  }
  
  /**
   * TODO
   */
  void runStartStuff(dataBase _dataBase){
    this.myDataBase = _dataBase;
    this.importThumbnailPhotos();
    //TODO
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
  
  ///
  void importThumbnailPhotos(){
    thumbnails.addAll(myDataBase.getAllThumbnails());
  }
  /**
   * TODO
   */
  void cleaner(){
    thumbnails.clear();
  }

}///allPhotos