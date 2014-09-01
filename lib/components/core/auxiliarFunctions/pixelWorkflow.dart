library pixelworkflow;

import '../photo/photo.dart';
import 'package:observe/observe.dart';
import 'dart:html';
import '../descriptor/descriptorFactory.dart';
import '../categories/facesCategory.dart';
import '../histogram/histogramManager.dart';

final _descriptorFactory = DescriptorFactory.get();
final _histogramManager = HistogramManager.get();

class PixelWorkflow extends Object with Observable {
  
  /**
   * Singleton
   */
  static PixelWorkflow _instance; 

  PixelWorkflow._();

  static PixelWorkflow get() {
    if (_instance == null) {
      _instance = new PixelWorkflow._();
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
        facePixels = 0,
        count = 0,
        facesCategory = FacesCategory.get(),
        grayPixel = 0;
        
        photo.setDataSaved(dimension);
    
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
   
      if(isGreyPixel(redChannel, greenChannel, blueChannel)) grayPixel++;
      numberOfIterations++;
    }
    
    //Histogram
    _histogramManager.receiveData(redValues, greenValues, blueValues, photo);
    
    var Red = (redValuesSum/numberOfIterations),
        Green = (greenValuesSum/numberOfIterations),
        Blue = (blueValuesSum/numberOfIterations),
        average = (Red+Green+Blue)/3; 
 
    var greyPercentage = grayPixel/numberOfIterations;
    if(greyPercentage < 0.10){
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
  
  bool isGreyPixel(int Red, int Green, int Blue){
    return ((Red == Green) && (Red == Blue));
  }
  
  // Get image pixels from image element.
  ImageData getPixels(ImageElement img) {
    var canvas = new CanvasElement(width: img.width, height: img.height);
    CanvasRenderingContext2D context = canvas.getContext('2d');
    context.drawImage(img, 0, 0);
    return context.getImageData(0, 0, canvas.width, canvas.height);
  }
  
}
  