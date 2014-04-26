library app;

import 'dart:html';
import 'package:route_hierarchical/client.dart';
import 'package:polymer/polymer.dart';

import 'dragAndDrop.dart';
import 'allPhotos.dart';
import 'summaryDone.dart';
import 'bigSizePhoto.dart';

import 'resources/screenModule.dart';

Map<String, screen> MODULES = {
  "drag-and-drop": new dragAndDrop(),
  "all-photos": new allPhotos(),
  "summary-done": new summaryDone(),
  "big-siz-ephoto": new bigSizePhoto()
};

/**
 * Memento App
 */
@CustomTag('memento-app')
class mementoApp extends PolymerElement {
 
  @published String pageName;

  Map<String, screen> get modules => MODULES;

  @observable screen module = null;

  // This lets the CSS "bleed through" into the Shadow DOM of this element.
  //bool get applyAuthorStyles => true;

  var router;

  pageNameChanged() {
    print("Page Name changed");
    // Setup the connectionId for all the modules
    modules.values.forEach((m) { m.setAttribute("pageName", pageName); });
  }

  mementoApp.created() : super.created() {
    
    print("CONSEGUI ENTRAR");

    // Setup the root
    router = new Router(useFragment: true);


    // Add a route for each module along with each module's custom subroutes
    modules.forEach((path, module) {
      print(path);
      router.root.addRoute(
          name: path,
          preEnter: (_) {
            this.module = modules[path];
          },
          path: '/$path',
          mount: module.mount(path, router));
    });

    // default handler

    router.root.addRoute(name: 'home', defaultRoute: true, path: '', enter: showHome);

    router.listen();
    
    
  }

  void showHome(RouteEvent e) {
    module = null;
  }

  /// Navigate to the home of the selected module
  void navigate(event, detail, target) {
   // module = 
    router.go('${target.dataset['target']}', {});
    
  }

  void moduleChanged() {
    $['module'].children..clear();
     if (module != null) {
       print('Element: ${module.tagName}');
       $['module'].children.add(module);
     }
  }

}
