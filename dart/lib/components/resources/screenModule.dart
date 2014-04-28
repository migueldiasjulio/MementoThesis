library screenModule;

import 'package:polymer/polymer.dart';
import 'package:route_hierarchical/client.dart';
export 'package:route_hierarchical/client.dart';
import '../core/dataBase.dart';

/**
 * TODO
 */
abstract class screenModule extends PolymerElement {

  /**
   * TODO
   */
  screenModule.created() : super.created() {}

}//class screen Module

/**
 * TODO
 */
abstract class screen extends screenModule {
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
  screen.created() : super.created();

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
     router.go("${target.dataset["path"]}", {});
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