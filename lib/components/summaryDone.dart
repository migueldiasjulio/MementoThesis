library summaryDone;

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:route_hierarchical/client.dart';
import 'resources/ScreenModule.dart' as screenhelper;
import 'core/DataBase.dart';

/**
 * TODO
 */
@CustomTag(SummaryDone.TAG)
class SummaryDone extends screenhelper.Screen {

  /**
   * TODO
   */
  static const String TAG = "summary-done";
  String title = "Summary Done",
         description = "Summary results";
  @observable Selection selection = null;
  factory SummaryDone() => new Element.tag(TAG);

  @override
  void enteredView() {

    super.enteredView();
  }
  
  /**
   * TODO
   */
  SummaryDone.created() : super.created();
  
  /**
   * TODO
   */
  void runStartStuff(dataBase _dataBase){
    this.myDataBase = _dataBase;
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

}