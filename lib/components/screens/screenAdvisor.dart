library screenAdvisor;

import 'package:observe/observe.dart';

/*
 * 
 */ 
class ScreenAdvisor extends Object with Observable {
   
  /**
   * Singleton
   */
  static ScreenAdvisor _instance; 
  String _screenName = "";

  /*
   * 
   */ 
  ScreenAdvisor._() {}

  /*
   * 
   */ 
  static ScreenAdvisor get() {
    if (_instance == null){
      _instance = new ScreenAdvisor._();
    }
    return _instance;
  }
  
  /*
   * 
   */ 
  String get screenName => _screenName;
  
  /*
   * 
   */ 
  void setScreenType(String screenName){
    _screenName = screenName;
  }
}