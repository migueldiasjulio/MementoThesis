library mathneeded;

import 'package:observe/observe.dart';
import 'dart:math';

class MementoMath extends Object with Observable {
   
  /**
   * Singleton
   */
  static MementoMath _instance; 

  MementoMath._() {}

  static MementoMath get() {
    if (_instance == null){
      _instance = new MementoMath._();
    }
    return _instance;
  }
  
  double mean(int firstNumber, int secondNumber){
    return firstNumber/secondNumber;
  }
   
  double standardDeviation(List<int> values, double mean){
    var result = 0.0;
    var size = values.length;
    var sum = 0.0;
     
    for(int value in values){
      var auxVar = (value - mean);  // (pij - Ei)^2
      auxVar = pow(auxVar, 2);
      sum += auxVar;
    }
  
    result = sum/size;
    result = sqrt(result);
      
    return result;
  }
  
  double skeweness(List<int> values, double mean){
    var result = 0.0;
    var size = values.length;
    var sum = 0.0;
     
    for(int value in values){
      var auxVar = (value - mean);  // (pij - Ei)^3
      auxVar = pow(auxVar, 3);
      sum += auxVar;
    }
  
    result = sum/size;
    if(result.isNegative){
      result = result.abs();
      result = cubeRoot(result);
      result = result*(-1.0);
    }else{
      result = cubeRoot(result);
    }

    return result;
  }
  
  double cubeRoot(double x) {  
     var aux =  1.0/3.0;
     return pow(x, aux);  
   } 
  
}