library app;

import 'package:route_hierarchical/client.dart';
import 'package:polymer/polymer.dart';
import 'dragAndDrop.dart';
import 'allPhotos.dart';
import 'summaryDone.dart';
import 'bigSizePhoto.dart';
import 'resources/ScreenModule.dart' as screenmodule;
import 'core/DataBase.dart';

/**
 * TODO
 */
Map<String, screenmodule.Screen> myScreens = {
  "drag-and-drop": new DragAndDrop(),
  "all-photos": new AllPhotos(),
  "summary-done": new SummaryDone(),
  "big-size-photo": new BigSizePhoto()
};

/**
 * Memento App
 */
@CustomTag('memento-app')
class MementoApp extends PolymerElement {
 
  /**
   * TODO
   */
  @published String pageName;
  Map<String, screenmodule.Screen> get screens => myScreens;
  @observable screenmodule.Screen myScreen = null;
  var router;
  dataBase myDataBase = null;

  // This lets the CSS "bleed through" into the Shadow DOM of this element.
  bool get applyAuthorStyles => true;

  /**
   * TODO
   */
  MementoApp.created() : super.created() {
    myDataBase = new dataBase(true); //TODO change to Singleton
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
    screens.forEach((path, module) {
      print(path);
      router.root.addRoute(
          name: path,
          preEnter: (_) {
            this.myScreen = screens[path];
            screens[path].runStartStuff(myDataBase);
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
    this.myScreen = null;
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
  void myScreenChanged() {
    $['myScreen'].children..clear();
     if (this.myScreen != null) {
       print('Element: ${this.myScreen.tagName}');
       $['myScreen'].children.add(this.myScreen);
     }
  }
}
