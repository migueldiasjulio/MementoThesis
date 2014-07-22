// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the COPYING file.

// This is a port of "Image Filters with Canvas" to Dart.
// See: http://www.html5rocks.com/en/tutorials/canvas/imagefilters/

library categorymanager;

import '../photo/photo.dart';
import 'facesCategory.dart' as faces;
import 'blackAndWhiteCategory.dart' as bw;
import 'colorCategory.dart' as color;
import 'similarCategory.dart' as similar;
import 'category.dart';
import 'package:observe/observe.dart';
import 'dart:html';
import 'dart:math';

class CategoryManager extends Object with Observable {
   
  /**
   * Singleton
   */
  static CategoryManager _instance; 
  final List<Category> categories = toObservable(new Set());

  CategoryManager._() {
    categories.add(faces.FacesCategory.get());
    categories.add(bw.BlackAndWhiteCategory.get());
    categories.add(color.ColorCategory.get());
    categories.add(similar.SimilarCategory.get());
  }

  static CategoryManager get() {
    if (_instance == null) {
      _instance = new CategoryManager._();
    }
    return _instance;
  }
  
  bool analyzePixels(List<Photo> photosToAnalyze){
    ImageData pixels;
    
    try{
      photosToAnalyze.forEach((photo){
        pixels = getPixels(photo.thumbnail.image);
        extractDescriptorAndColorInfo(photo, pixels);
      });
    } catch(Exception){
      //TODO something      
    }
      
    return true;
  }
  
  // Get image pixels from image element.
  ImageData getPixels(ImageElement img) {
    var canvas = new CanvasElement(width: img.width, height: img.height);
    CanvasRenderingContext2D context = canvas.getContext('2d');
    context.drawImage(img, 0, 0);
    return context.getImageData(0, 0, canvas.width, canvas.height);
  }
  
  // Apply grayscale filter.
  ImageData grayscale(ImageData pixels) {
    var d = pixels.data;
    for (var i = 0; i < d.length; i += 4) {
      var r = d[i];
      var g = d[i+1];
      var b = d[i+2];
      // CIE luminance for the RGB
      var v = (0.2126 * r).toInt() + (0.7152 * g).toInt() + (0.0722 * b).toInt();
      d[i] = d[i + 1] = d[i + 2] = v;
    }
    return pixels;
  }
  
  void extractDescriptorAndColorInfo(Photo photo, ImageData pixels) {
    var dimension = pixels.data,
        redValues = new List<int>(),
        greenValues = new List<int>(),
        blueValues = new List<int>(),
        redValuesSum = 0,
        greenValuesSum = 0,
        blueValuesSum = 0,
        redChannel = 0,
        greenChannel = 0,
        blueChannel = 0, 
        isColor = false,
        numberOfPixelsCounted = 0,
        numberOfIterations = 0;
    
    var d = pixels.data;
    var redValueInBW = 0.0;
    var greenValueInBW = 0.0;
    var blueValueInBW = 0.0;
    
    for (var i = 0; i < dimension.length; i += 4) {
      
      //RED CHANNEL
      redChannel = dimension[i];
      redValues.add(redChannel);
      redValuesSum += redChannel;
      
      //GREEN CHANNEL
      greenChannel = dimension[i+1];
      greenValues.add(greenChannel);
      greenValuesSum += greenChannel;
      
      //BLUE CHANNEL
      blueChannel = dimension[i+2];
      blueValues.add(blueChannel);
      blueValuesSum += blueChannel;
      
      //MAKE THE COLOR CHECK
      var v = (0.2126 * redChannel).toInt() + (0.7152 * greenChannel).toInt() + (0.0722 * blueChannel).toInt();
      d[i] = d[i + 1] = d[i + 2] = v;
      redValueInBW += d[i];
      greenValueInBW += d[i+1];
      blueValueInBW += d[i+2];
      numberOfIterations++;
    }
    
    var Red = (redValuesSum/numberOfIterations);
    var Green = (greenValuesSum/numberOfIterations);
    var Blue = (blueValuesSum/numberOfIterations);
    var average = (Red+Green+Blue)/3;
    
    print("Red Values: " + Red.toString());
    print("Green Values: " + Green.toString());
    print("Blue Values: " + Blue.toString());
    print("Average value" + average.toString());
    
    
    
    var RedBW = (redValueInBW/numberOfIterations);
    var GreenBW = (greenValueInBW/numberOfIterations);
    var BlueBW = (blueValueInBW/numberOfIterations);
    var averageBW = (RedBW+GreenBW+BlueBW)/3;
    
    print("Red BW Values: " + RedBW.toString());
    print("Green BW Values: " + GreenBW.toString());
    print("Blue BW Values: " + BlueBW.toString());
    print("Average BW value" + averageBW.toString());
    
    var difference = (average - averageBW).abs();
    if(difference > 2.0){
      photo.thisOneIsColor();
    }
    
    doMathAndBuildDescriptor(photo, redValues, redValuesSum, 
                                    greenValues, greenValuesSum,  
                                    blueValues, blueValuesSum);
  }
  
  void doMathAndBuildDescriptor(Photo photo, List<int> redValues, int redValuesSum, 
                                List<int> greenValues, int greenValuesSum,
                                List<int> blueValues, int blueValuesSum){
    
  var size = redValues.length; //The same for the other channels
  var descriptor = new List<double>();
  
  //Mean Calculation
  var redValueMean = redValuesSum/size;
  var greenValueMean = greenValuesSum/size;
  var blueValueMean = blueValuesSum/size;
  
  //Standard Deviation
  var redStandardDeviation = standardDeviation(redValues, redValueMean);
  var greenStandardDeviation = standardDeviation(greenValues, greenValueMean);
  var blueStandardDeviation = standardDeviation(blueValues, blueValueMean);
  
  //Skewness
  var redSkewness = skeweness(redValues, redValueMean);
  var greenSkewness = skeweness(greenValues, greenValueMean);
  var blueSkewness = skeweness(blueValues, blueValueMean);
  
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
  print("Descriptor of " + photo.title + ": " + photo.photoDescriptor.toString());
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
  
  /**
   * Pipeline to extract categories from photos
   */ 
  void categoriesPipeline(List<Photo> photosToAnalyze){
    if(photosToAnalyze.isNotEmpty){
      if(analyzePixels(photosToAnalyze)){
        categories.forEach((category){
          category.work(photosToAnalyze);
        }); 
      }
    }
    print("Categories Assigned!");
  }
}