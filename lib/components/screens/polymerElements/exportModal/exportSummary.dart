library exportsummary;

import 'package:polymer/polymer.dart';
import 'dart:core';
export "package:polymer/init.dart";
export 'package:route_hierarchical/client.dart';
import '../../../core/database/dataBase.dart';
import 'dart:html';
import 'dart:core';
import 'package:bootjack/bootjack.dart';

/*
 * 
 */ 
typedef void exportToHardDrive();

@CustomTag('export-summary')
class ExportSummary extends PolymerElement {
  
  bool get applyAuthorStyles => true;
  bool get preventDispose => true;
  
  @published exportToHardDrive exportToHardDriveFunction;
  @published bool downloading;
  @published bool openExportModal;
  
  bool modalIsOff = true;
  Modal exportMenu;
  
  /*
   * 
   */ 
  ExportSummary.created() : super.created(){
    Modal.use(); 
  }
  
  openExportModalChanged(){    
    if(!modalIsOff){
      hiddeModal();
      modalIsOff = true;
    }
    if(modalIsOff){
      showModal();
      modalIsOff = false;
    }
  }
  
  void showModal(){
    if (exportMenu == null) exportMenu = Modal.wire($['exportMenu']);
    exportMenu.show();
  }
  
  void hiddeModal(){
    if (exportMenu == null) exportMenu = Modal.wire($['exportMenu']);
    exportMenu.hide();
  }
  
  void exportToHardDrivePlease() => exportToHardDriveFunction();
  
}