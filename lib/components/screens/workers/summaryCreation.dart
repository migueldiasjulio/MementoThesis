library summaryCreation;

import 'dart:isolate';
import 'dart:html';
import 'package:observe/observe.dart';
import '../../core/photo/photo.dart';
import '../../core/database/dataBase.dart';

class SummaryCreation extends Object with Observable {
  
  static SummaryCreation _instance;
  
  SummaryCreation._();
  
  static SummaryCreation get() {
    if (_instance == null) {
      _instance = new SummaryCreation._();
    }
    return _instance;
  }
   
   runInIsolate(SendPort sendPort, List<Photo> photos, int numberDefinedInt) {
     
    //Stablishing connection 
    ReceivePort receivePort = new ReceivePort();
    sendPort.send(receivePort.sendPort);

    receivePort.listen((msg) {
      
      if(msg == "STOP"){  }
      
      DB.buildSummary(photos, numberDefinedInt);
      
      sendPort.send("Process is finished!");

    });
  }
}