library databaseauxiliarfunction;

import 'package:observe/observe.dart';
import '../auxiliarFunctions/mementoMath.dart';
import '../photo/photo.dart';

//COLOR MOMENTS DESCRIPTOR
class DatabaseAuxiliarFunctions extends Object with Observable {
  
 /**
  * Singleton
  */
 static DatabaseAuxiliarFunctions _instance; 

 DatabaseAuxiliarFunctions._() {}

 static DatabaseAuxiliarFunctions get() {
   if (_instance == null){
     _instance = new DatabaseAuxiliarFunctions._();
   }
   return _instance;
 }
 
}