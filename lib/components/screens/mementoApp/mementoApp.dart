library app;

import 'package:route_hierarchical/client.dart';
import 'package:polymer/polymer.dart';
export "package:polymer/init.dart";
import '../allPhotos/allPhotos.dart';
import '../summaryDone/summaryDone.dart';
import '../bigSizePhoto/bigSizePhoto.dart';
import '../../core/screenModule.dart' as screenmodule;
import '../../core/database/dataBase.dart';
import '../../core/settings/mementoSettings.dart';
import '../../core/settings/index.dart';

/**
 * Screeen Modules of Memento
 */
Map<String, screenmodule.ScreenModule> myScreens = {
  "all-photos": new AllPhotos(),
  "summary-done": new SummaryDone(),
  "big-size-photo": new BigSizePhoto()
};

/**
 * Memento App
 */
@CustomTag('memento-app')
class MementoApp extends PolymerElement {

  @published String pageName;
  @observable screenmodule.ScreenModule myScreen = null;
  Map<String, screenmodule.ScreenModule> get screens => myScreens;
  var router;
  Index _index = Index.get();
  MementoSettings settings = MementoSettings.get();
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
   * Show Home 
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
   * When the screen is changed
   */
  void myScreenChanged() {
    $['myScreen'].children..clear();
     if (this.myScreen != null) {
       print('Element: ${this.myScreen.tagName}');
       $['myScreen'].children.add(this.myScreen);
     }
  }
}