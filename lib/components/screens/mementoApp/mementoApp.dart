library app;

import 'package:route_hierarchical/client.dart';
import 'package:polymer/polymer.dart';
import '../allPhotos/allPhotos.dart';
import '../summaryDone/summaryDone.dart';
import '../bigSizePhoto/bigSizePhoto.dart';
import '../../core/screenModule.dart' as screenmodule;
import '../../core/dataBase.dart';

/**
 * TODO
 */
Map<String, screenmodule.Screen> myScreens = {
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
  //@observable bool defaultScreen = true;
  var router;
  Database myDataBase = Database.get();

  /**
   * TODO
   */
  MementoApp.created() : super.created() {
    router = new Router(useFragment: true);
    screens.forEach((path, module) {
      print(path);
      router.root.addRoute(
          name: path,
          preEnter: (_) {
            this.myScreen = screens[path];
            this.myScreen.runStartStuff();
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
