library allPhotos;

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:route_hierarchical/client.dart';
import 'resources/ScreenModule.dart' as screenhelper;
import 'core/DataBase.dart';

/**
 * TODO
 */
@CustomTag(AllPhotos.TAG)
class AllPhotos extends screenhelper.Screen {

  /**
   * TODO
   */
  static const String TAG = "all-photos";

  /**
   * TODO
   */
  String title = "All Photos",
         description = "Showing all photos";

  /**
   * TODO
   */
  @observable Selection selection = null;

  /**
   * TODO
   */
  factory AllPhotos() => new Element.tag(TAG);

  /**
   * TODO
   */
  AllPhotos.created() : super.created();
  
  /**
   * TODO
   */
  void runStartStuff(dataBase _dataBase){
    this.myDataBase = _dataBase;
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

  /**
   * TODO
   */
  select(event, detail, target) {
    // <type>-<id>
    var id = target.dataset["id"].split("-");
    router.go("$path.view", {"type": id[0], "id": id[1]});
  }
}//allPhotos