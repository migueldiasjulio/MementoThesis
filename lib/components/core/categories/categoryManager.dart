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
  
  void extractDescriptorAndColorInfo(Photo photo, ImageData pixels) {
    var dimension = pixels.data;
    var redValues = new List<int>();
    var greenValues = new List<int>();
    var blueValues = new List<int>();
    var redValuesSum = 0;
    var greenValuesSum = 0;
    var blueValuesSum = 0;
    var redChannel = 0;
    var greenChannel = 0;
    var blueChannel = 0;
    
    var isColor = false;
    var numberOfPixelsCounted = 0;
    final int totalNumber = 3;
        
    print("Starting " + photo.title + " pixel maths");
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
    }
    
    doMathAndBuildDescriptor(photo, redValues, redValuesSum, 
                                    greenValues, greenValuesSum,  
                                    blueValues, blueValuesSum);
    
    print("Photo: " + photo.title + " done!");
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
  print("Descriptor: " + photo.photoDescriptor.toString());
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
    print("Result2: " + result.toString());
    if(result.isNegative){
      print("Is negative!");
      result = result.abs();
      print("Result2POSITIVE: " + result.toString());
      result = cubeRoot(result);
      //result *= -1;
    }else{
      result = cubeRoot(result);
    }
    print("Result3: " + result.toString());

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