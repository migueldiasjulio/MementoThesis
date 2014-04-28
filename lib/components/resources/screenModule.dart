library screenModule;

import 'package:polymer/polymer.dart';
import 'package:route_hierarchical/client.dart';
export 'package:route_hierarchical/client.dart';
import '../core/DataBase.dart';

/**
 * TODO
 */
abstract class ScreenModule extends PolymerElement {

  /**
   * TODO
   */
  ScreenModule.created() : super.created();
}//class screen Module

/**
 * TODO
 */
abstract class Screen extends ScreenModule {
  /**
   * TODO
   */
  String title, description;
  String path;
  Router router;
  dataBase myDataBase;

  /**
   * TODO
   */
  Screen.created() : super.created();

  // This lets the CSS "bleed through" into the Shadow DOM of this element.
  bool get applyAuthorStyles => true;

  /**
   * Store the root router and return the mountFn
   */
  mount(String path, Router router) {
    this.path = path;
    this.router = router;
    return setupRoutes;
  }

  /**
   * TODO
   */
  void setupRoutes(Route route);
  
  /**
   * TODO
   */
  void runStartStuff(dataBase myDataBase);

  /**
   * TODO
   */
  navigate(event, detail, target) {
     router.go("${target.dataset["target"]}", {});
  }

  /**
   * TODO
   */
  goHome() {
    router.go("home", {});
  }

  /**
   * TODO
   */
  goRoot() {
    router.go(path, {});
  } 
  /*
  goAllPhotos(){
    router.go("all-photos", {});
  }*/
}