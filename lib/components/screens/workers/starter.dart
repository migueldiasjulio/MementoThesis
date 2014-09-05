library starter;

import 'dart:isolate';
import 'dart:html';
import 'package:observe/observe.dart';
import '../../core/photo/photo.dart';
import '../../core/database/dataBase.dart';
import 'dart:js' as js show JsObject, context;

class Starter extends Object with Observable {
  
  static Starter _instance;
  static List<Photo> _processedPhotos = new List<Photo>();
  static List<FileReader> _fileReaders = new List<FileReader>();
  bool notKilled = true;
  
  Starter._();
  
  static Starter get() {
    if (_instance == null) {
      _instance = new Starter._();
    }
    return _instance;
  }
  
  void cleanProcessedPhotos() => _processedPhotos.clear();
  void cleanFileReaders() => _fileReaders.clear();
  
  List<Photo> get damnPhotos => _processedPhotos;
  
  void killFileReaders(){
    _fileReaders.forEach((fileReader){
      fileReader.abort(); 
    });
  }
   
   runInIsolate(SendPort sendPort,  
                List<File> filesToProcess,
                js.JsObject exif) {
     
    //Stablishing connection 
    ReceivePort receivePort = new ReceivePort();
    sendPort.send(receivePort.sendPort); 

    receivePort.listen((msg) {
      var photoToAdd = null,
          dateInformation = 0.0,
          number = 0.0;
      
      if(msg == "STOP"){ killFileReaders(); }
      
      for(File file in filesToProcess){
        FileReader reader = new FileReader();
        _fileReaders.add(reader);
        
        reader.onLoad.listen((e){
          photoToAdd = new Photo(reader.result, file.name);
          
          //dateInformation = DB.extractExifInformation(photoToAdd);
          dateInformation = file.lastModified;
          
          var photo = photoToAdd.image;

          //var faceDetectorX = faceDetector.callMethod('comp',[photo]);
          //print(faceDetectorX.toString());
          print("EXIF: " + exif.toString());
          var exifWorking = exif.callMethod('pretty',[photo]);
          print("Exif info: " + exifWorking.toString()); 
          
          photoToAdd.setLastModifiedInformation(file.lastModifiedDate);
          photoToAdd.setDataFromPhoto(dateInformation.ceilToDouble());
          _processedPhotos.add(photoToAdd);
          number++;
          
          if(number == filesToProcess.length){
            DB.sortPhotos(_processedPhotos);
            sendPort.send("Process is finished!");
          }   
        });
        reader.readAsDataUrl(file);      
      }
    });
  }
}