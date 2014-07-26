library descriptorFactory;

import 'package:observe/observe.dart';
import '../mementoMath.dart';
import '../photo/photo.dart';

final _mementoMath = MementoMath.get();

//COLOR MOMENTS DESCRIPTOR
class DescriptorFactory extends Object with Observable {
  
 /**
  * Singleton
  */
 static DescriptorFactory _instance; 

 DescriptorFactory._() {}

 static DescriptorFactory get() {
   if (_instance == null){
     _instance = new DescriptorFactory._();
   }
   return _instance;
 }
 
  void doMathAndBuildDescriptor(Photo photo, List<int> redValues, int redValuesSum, 
                                List<int> greenValues, int greenValuesSum,
                                List<int> blueValues, int blueValuesSum){
    
  var size = redValues.length; //The same for the other channels
  var descriptor = new List<double>();
  
  //Mean Calculation
  var redValueMean = _mementoMath.mean(redValuesSum, size); 
  var greenValueMean = _mementoMath.mean(greenValuesSum, size); 
  var blueValueMean = _mementoMath.mean(blueValuesSum, size); 
  
  //Standard Deviation
  var redStandardDeviation = _mementoMath.standardDeviation(redValues, redValueMean);
  var greenStandardDeviation = _mementoMath.standardDeviation(greenValues, greenValueMean);
  var blueStandardDeviation = _mementoMath.standardDeviation(blueValues, blueValueMean);
  
  //Skewness
  var redSkewness = _mementoMath.skeweness(redValues, redValueMean);
  var greenSkewness = _mementoMath.skeweness(greenValues, greenValueMean);
  var blueSkewness = _mementoMath.skeweness(blueValues, blueValueMean);
  
  //RED
  descriptor.add(redValueMean);
  descriptor.add(redStandardDeviation);
  descriptor.add(redSkewness);
  
  //GREEN
  descriptor.add(greenValueMean);
  descriptor.add(greenStandardDeviation);
  descriptor.add(greenSkewness);
  
  //BLUE
  descriptor.add(blueValueMean);
  descriptor.add(blueStandardDeviation);
  descriptor.add(blueSkewness);
  
  photo.setDescriptor(descriptor);
  //print("Descriptor of " + photo.title + ": " + photo.photoDescriptor.toString());
  }
}