library summaryCreation;

import 'dart:isolate';
import 'package:observe/observe.dart';
import '../../core/photo/photo.dart';
import '../../core/database/dataBase.dart';
import '../1Stage/auxiliarFunctions/firstAuxFunctions.dart';

final _firstAuxFunctions = FirstAuxFunctions.get();

class SummaryCreation extends Object with Observable {
  
  static SummaryCreation _instance;
  
  SummaryCreation._();
  
  static SummaryCreation get() {
    if (_instance == null) {
      _instance = new SummaryCreation._();
    }
    return _instance;
  }
   
   runInIsolate() {
     
    SendPort sendPort = _firstAuxFunctions.sendPort;
    List<Photo> photos = _firstAuxFunctions.photos;
    int numberDefinedInt = _firstAuxFunctions.numberDefinedInt;
    //Stablishing connection 
    ReceivePort receivePort = new ReceivePort();
    sendPort.send(receivePort.sendPort);

    receivePort.listen((msg) {
      
      if(msg == "STOP"){  }
      
      photos.sort();
      DB.buildSummary(photos, numberDefinedInt);
      
      sendPort.send("Process is finished!");

    });
  }
}