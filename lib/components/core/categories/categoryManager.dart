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
import 'facesCategory.dart';
import 'dart:html';
import 'descriptorFactory.dart';

final _descriptorFactory = DescriptorFactory.get();

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
    var returnValue = false;
    
    try{
      photosToAnalyze.forEach((photo){
        pixels = getPixels(photo.thumbnail.image);
        extractDescriptorAndColorInfo(photo, pixels);
        returnValue =  true;
      });
    } catch(Exception){
      //TODO something      
    }
      
    return returnValue;
  }
  
  // Get image pixels from image element.
  ImageData getPixels(ImageElement img) {
    var canvas = new CanvasElement(width: img.width, height: img.height);
    CanvasRenderingContext2D context = canvas.getContext('2d');
    context.drawImage(img, 0, 0);
    return context.getImageData(0, 0, canvas.width, canvas.height);
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
        numberOfIterations = 0,
        d = pixels.data,
        redValueInBW = 0.0,
        greenValueInBW = 0.0,
        blueValueInBW = 0.0,
        facePixels = 0,
        count = 0,
        facesCategory = FacesCategory.get();
    
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
      
      //if(numberOfIterations < 5){
        redValueInBW += d[i];
        greenValueInBW += d[i+1];
        blueValueInBW += d[i+2];
        
        //print("Red difference: " + (d[i] - redChannel).abs().toString());
        //print("Green difference: " + (d[i+1] - greenChannel).abs().toString());        
        //print("Blue difference: " + (d[i+2] - blueChannel).abs().toString());       
      //}
      
      //face Recognition
      count = 0;
      if(facesCategory.isSkinRGB(redChannel, greenChannel, blueChannel)){
        count+= 1;
      }
      if(facesCategory.isSkinYCrCb(redChannel, greenChannel, blueChannel)){
        count+= 1;
      }
      if(facesCategory.isSkinHSI(redChannel, greenChannel, blueChannel)){
        count+= 1;
      }
      if(count == 3){ 
        facePixels+= 1;
      }
   
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
    
    _descriptorFactory.doMathAndBuildDescriptor(photo, redValues, redValuesSum, 
                                    greenValues, greenValuesSum,  
                                    blueValues, blueValuesSum);
    
    //Face Detector
    if(facePixels > 1000){
      photo.thisOneHasFaces();
    }
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