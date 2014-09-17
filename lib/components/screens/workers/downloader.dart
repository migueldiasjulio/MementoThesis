library downloader;

import 'dart:isolate';
import 'dart:html';
import 'package:observe/observe.dart';
import '../../core/photo/photo.dart';
import '../../core/database/dataBase.dart';
import 'dart:js' as js show JsObject, context;

class Downloader extends Object with Observable {

  static Downloader _instance;

  Downloader._();

  static Downloader get() {
    if (_instance == null) {
      _instance = new Downloader._();
    }
    return _instance;
  }

  runInIsolate(SendPort sendPort, Container summaryContainer) {

    //Stablishing connection
    ReceivePort receivePort = new ReceivePort();
    sendPort.send(receivePort.sendPort);

    receivePort.listen((msg) {

      if (msg == "STOP") {}

      var zipInstance = new js.JsObject(js.context['JSZip'], []);
      zipInstance.callMethod('file', ["README.txt", "Your resulted summary is inside '" 'Summary Photos' "' folder.\n"]);
      var imgFolder = zipInstance.callMethod('folder', ["Summary Photos"]);

      //LOOP HERE
      //var img = zip.folder("images");
      var summaryPhotos = summaryContainer.photos,
          summaryFiles = DB.giveMeAllSummaryFiles(),
          size = summaryPhotos.length,
          fileName = "",
          file,
          imgData;
      for (int i = 0; i < size; i++) {
        fileName = summaryFiles.elementAt(i).name;
        file = summaryFiles.elementAt(i);
        imgData = summaryPhotos.elementAt(i).image.src;
        imgFolder.callMethod('file', [fileName, imgData , ""]);
      }

      //zip.file("hello.txt").asUint8Array();
      //img.file("smile.gif", imgData, {base64: true});

      var content = zipInstance.callMethod('generate', []);
      var fileSaver = js.context.callMethod('saveAs', [content, 'memento.zip']);

      sendPort.send("Process is finished!");
    });
  }
}
