library bigSize;

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'resources/screenModule.dart';

@CustomTag(TAG)
class bigSizePhoto extends screen {

  static const String TAG = "big-size-photo";

  String title = "Big Size Photo",
         description = "Photo big size";

  @observable Selection selection = null;

  factory bigSizePhoto() => new Element.tag(TAG);

  bigSizePhoto.created() : super.created() {
  }

  @override
   void setupRoutes(Route route) {
    route.addRoute(
        name: 'home',
        path: '',
        enter: home);
   }

  home(_) {

  }
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

  select(event, detail, target) {
    // <type>-<id>
    var id = target.dataset["id"].split("-");
    router.go("$path.view", {"type": id[0], "id": id[1]});
  }
}