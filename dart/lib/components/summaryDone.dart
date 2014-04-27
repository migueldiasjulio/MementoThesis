library summaryDone;

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'resources/screenModule.dart';

/**
 * TODO
 */
@CustomTag(TAG)
class summaryDone extends screen {

  /**
   * TODO
   */
  static const String TAG = "summary-done";
  String title = "Summary Done",
         description = "Summary results";
  @observable Selection selection = null;
  factory summaryDone() => new Element.tag(TAG);

  /**
   * TODO
   */
  summaryDone.created() : super.created() {}
  
  /**
   * TODO
   */
  void runStartStuff(){
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