library summaryManipulationAuxiliar;

import 'dart:html';
import 'package:observe/observe.dart';
import '../defaultScreen/screenModule.dart' as screenhelper;

class SummaryManipulationAuxiliar extends Object with Observable{
  
  static SummaryManipulationAuxiliar _instance; 

  SummaryManipulationAuxiliar._(); 
  
  static SummaryManipulationAuxiliar get() {
    if (_instance == null) {
      _instance = new SummaryManipulationAuxiliar._();
    }
    return _instance;
  }
}