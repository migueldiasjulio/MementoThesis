library mementosettings;

import 'dataBase.dart';
import 'dart:math';

class MementoSettings {

  /**
   * Singleton
   */
  static MementoSettings _instance;

  MementoSettings._();

  static MementoSettings get() {
    if (_instance == null) {
      _instance = new MementoSettings._();
    }
    return _instance;
  }
  

}//dataBase