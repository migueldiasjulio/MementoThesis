library summaryAlgorithm;

import 'package:observe/observe.dart';

abstract class SummaryAlgorithm extends Object with Observable {
  
  /*
   * 
   */ 
  final String name;
  
  /*
   * 
   */ 
  SummaryAlgorithm(this.name);
  
  /*
   * 
   */ 
  void applyAlgorithm(int numberOfSummaryPhotos);
}
