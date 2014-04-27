library app;

import 'dart:html';
import 'package:route_hierarchical/client.dart';
import 'package:polymer/polymer.dart';
import 'dragAndDrop.dart';
import 'allPhotos.dart';
import 'summaryDone.dart';
import 'bigSizePhoto.dart';
import 'resources/screenModule.dart';

/**
 * TODO
 */
Map<String, screen> MODULES = {
  "drag-and-drop": new dragAndDrop(),
  "all-photos": new allPhotos(),
  "summary-done": new summaryDone(),
  "big-size-photo": new bigSizePhoto()
};

/**
 * Memento App
 */
@CustomTag('memento-app')
class mementoApp extends PolymerElement {
 
  /**
   * TODO
   */
  @published String pageName;
  Map<String, screen> get modules => MODULES;
  static Map<String, screen> get myModules => MODULES;
  @observable screen module = null;
  var router;

  /**
   * TODO
   */
  pageNameChanged() {
    print("Page Name changed");
    // Setup the connectionId for all the modules
    modules.values.forEach((m) { m.setAttribute("pageName", pageName); });
  }

  /**
   * TODO
   */
  mementoApp.created() : super.created() {
    router = new Router(useFragment: true);

    // Add a route for each module along with each module's custom subroutes
    /*
     * router.root
  ..addRoute(
     name: 'usersList',
     path: '/users',
     defaultRoute: true,
     enter: showUsersList)
  ..addRoute(
     name: 'user',
     path: '/user/:userId',
     mount: (router) =>
       router
         ..addDefaultRoute(
             name: 'articleList',
             path: '/acticles',
             enter: showArticlesList)
         ..addRoute(
             name: 'article',
             path: '/article/:articleId',
             mount: (router) =>
               router
                 ..addDefaultRoute(
                     name: 'view',
                     path: '/view',
                     enter: viewArticle)
                 ..addRoute(
                     name: 'edit',
                     path: '/edit',
                     enter: editArticle)))
     */
    /*
    
    router.root
      ..addRoute(
         name: 'drag-and-drop',
         path: '/drag-and-drop',
         preEnter: (_) {
           this.module = modules['drag-and-drop'];
         },
         mount: (router) =>
           router
             ..addRoute(
                 name: 'all-photos',
                 path: '/all-photos'));
    */            
    modules.forEach((path, module) {
      print(path);
      router.root.addRoute(
          name: path,
          preEnter: (_) {
            this.module = modules[path];
            modules[path].runStartStuff();
          },
          path: '/$path',
          mount: module.mount(path, router));
    });
    router.root.addRoute(name: 'home', defaultRoute: true, path: '', enter: showHome);
    router.listen();  
  }

  /**
   * TODO
   */
  void showHome(RouteEvent e) {
    module = null;
  }
  
  /**
   * TODO
   */
  void changeDragAndDropInstance(){
    modules['drag-and-drop'] = new dragAndDrop();
  }

  /**
   * Navigate to the home of the selected module
   */
  void navigate(event, detail, target) {
   // module = 
    //changeDragAndDropInstance();
    router.go('${target.dataset['target']}', {});  
  }

  /**
   * TODO
   */
  void moduleChanged() {
    $['module'].children..clear();
     if (module != null) {
       print('Element: ${module.tagName}');
       $['module'].children.add(module);
     }
  }
}
