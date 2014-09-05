library starter;

import 'dart:isolate';
import 'dart:html';
import 'dart:typed_data';
import 'package:observe/observe.dart';
import '../../core/photo/photo.dart';
import '../../core/database/dataBase.dart';
import 'dart:js' as js show JsObject, context;
import '../../core/exif/exifData.dart';

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
                List<File> filesToProcess) {

     js.JsObject exif = js.context['EXIF'];

    //Stablishing connection
    ReceivePort receivePort = new ReceivePort();
    sendPort.send(receivePort.sendPort);

    receivePort.listen((msg) {
      var number = 0.0;

      if(msg == "STOP"){ killFileReaders(); }

      for(File file in filesToProcess){

        var photo = new Photo(Url.createObjectUrlFromBlob(file), file.name),
            exifData;

        //var faceDetectorX = faceDetector.callMethod('comp',[photo]);
        //print(faceDetectorX.toString());

        photo.image.onLoad.listen((_) {
          exif.callMethod('getData',[photo.image, () {
            
            var model = exif.callMethod('getTag', [photo.image, 'Model']),
                dataCreation = exif.callMethod('getTag', [photo.image, 'DateTimeOriginal']);
            
            exifData = new ExifData(photo.id, file.lastModifiedDate, dataCreation);
            photo.setExifData(exifData);
            photo.setDataFromPhoto();

            _processedPhotos.add(photo);
            number++;

            if(number == filesToProcess.length){
              DB.sortPhotos(_processedPhotos);
              sendPort.send("Process is finished!");
            }
          }]);
        });

      }
    });
  }
}