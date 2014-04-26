library screenModule;

import 'dart:js' as js;
import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:route_hierarchical/client.dart';
export 'package:route_hierarchical/client.dart';

/// An element which requires a Nuxeo connection
abstract class screenModule extends PolymerElement {

  @published String pageName;

  screenModule.created() : super.created() {
    print("[Screen] $this created with pageName $pageName");
  }

  pageNameChanged() {
    /*
    connection = document.querySelector("#$connectionId");
    print("$this connection '$connectionId' found ${connection}");
    _trigger(connection.isConnected);
    new PathObserver(connection, 'isConnected').open(_trigger);
    */
  }
}

abstract class screen extends screenModule {
  String title, description;

  String path;
  var router;

  screen.created() : super.created();

  // Store the root router and return the mountFn
  mount(String path, Router router) {
    this.path = path;
    this.router = router;
    return setupRoutes;
  }

  void setupRoutes(Route route);

  navigate(event, detail, target) {
     router.go("${target.dataset["path"]}", {});
  }

  goHome() {
    router.go("home", {});
  }

  goRoot() {
    router.go(path, {});
  }

}