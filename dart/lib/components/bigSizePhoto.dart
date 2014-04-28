library bigSize;

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'resources/screenModule.dart';
import 'core/dataBase.dart';

/**
 * TODO
 */
@CustomTag(TAG)
class bigSizePhoto extends screen {

  /**
   * TODO
   */
  static const String TAG = "big-size-photo";

  /**
   * TODO
   */
  String title = "Big Size Photo",
         description = "Photo big size";

  /**
   * TODO
   */
  @observable Selection selection = null;

  /**
   * TODO
   */
  factory bigSizePhoto() => new Element.tag(TAG);

  /**
   * TODO
   */
  bigSizePhoto.created() : super.created() {}
  
  /**
   * TODO
   */
  void runStartStuff(dataBase dataBase){
    this.myDataBase = dataBase;
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
    /*
     route.addRoute(
         name: 'view',
         path: '/:type/:id',
         enter: (e) {
           selection = new Selection()
           ..type = e.parameters['type']
           ..id = e.parameters['id'];
         },
         leave: (e) {
           jQuery('#diagram').callMethod('popup', ['remove']);
         }
     );
     */

  /**
   * TODO
   */
  select(event, detail, target) {
    // <type>-<id>
    var id = target.dataset["id"].split("-");
    router.go("$path.view", {"type": id[0], "id": id[1]});
  }
}