library mathwithdescriptor;

import 'package:observe/observe.dart';
import '../auxiliarFunctions/mementoMath.dart';

final _mementoMath = MementoMath.get();

//COLOR MOMENTS DESCRIPTOR
class MathWithDescriptor extends Object with Observable {
  
 /**
  * Singleton
  */
 static MathWithDescriptor _instance; 

 MathWithDescriptor._() {}

 static MathWithDescriptor get() {
   if (_instance == null){
     _instance = new MathWithDescriptor._();
   }
   return _instance;
 }
 
 List<List<double>> calcDistances(List<double> photosDateInfo){
   var distances = new List<List<double>>(),
       size = photosDateInfo.length,
       distance = 0.0,
       listOfDistances = new List<double>();
   for(int i = 0; i < size; i++){
     for(int j = 0; j < size; j++){
       distance = (photosDateInfo.elementAt(j) - photosDateInfo.elementAt(i)).abs();
       listOfDistances.add(distance);     
     }
     distances.insert(i, listOfDistances);
     listOfDistances = new List<double>();
   }
   
   return distances;
 }
 
}